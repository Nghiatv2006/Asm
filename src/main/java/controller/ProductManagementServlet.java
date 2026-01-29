package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import model.*;
import utils.JpaUtil;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class ProductManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "images";

    public ProductManagementServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        EntityManager em = JpaUtil.getEntityManager();

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = em.find(Product.class, id);
                request.setAttribute("product", product);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin();
                    
                    // Bước 1: Xóa khỏi ProductWishlist
                    em.createNativeQuery("DELETE FROM ProductWishlist WHERE ProductId = :id")
                        .setParameter("id", id)
                        .executeUpdate();
                    
                    // Bước 2: Xóa khỏi ProductInteractions
                    em.createNativeQuery("DELETE FROM ProductInteractions WHERE ProductId = :id")
                        .setParameter("id", id)
                        .executeUpdate();
                    
                    // Bước 3: Set ProductId = NULL trong OrderDetails
                    em.createNativeQuery("UPDATE OrderDetails SET ProductId = NULL WHERE ProductId = :id")
                        .setParameter("id", id)
                        .executeUpdate();
                    
                    // Bước 4: Xóa Product
                    int deletedCount = em.createNativeQuery("DELETE FROM Products WHERE Id = :id")
                        .setParameter("id", id)
                        .executeUpdate();
                    
                    tx.commit();
                    
                    if (deletedCount > 0) {
                        session.setAttribute("message", "Xóa sản phẩm thành công!");
                        session.setAttribute("messageType", "success");
                    } else {
                        session.setAttribute("message", "Không tìm thấy sản phẩm!");
                        session.setAttribute("messageType", "error");
                    }
                    
                } catch (Exception e) {
                    if (tx.isActive()) tx.rollback();
                    e.printStackTrace();
                    session.setAttribute("message", "Lỗi: " + e.getMessage());
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }

            List<Product> products = em.createQuery(
                "SELECT p FROM Product p JOIN FETCH p.category ORDER BY p.id DESC", Product.class)
                .getResultList();
            
            List<Category> categories = em.createQuery(
                "SELECT c FROM Category c ORDER BY c.categoryName", Category.class)
                .getResultList();
            
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/admin-products.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        String bookTitle = request.getParameter("bookTitle");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        String priceParam = request.getParameter("price");
        String stockParam = request.getParameter("stockQuantity");
        String description = request.getParameter("description");
        String categoryIdParam = request.getParameter("categoryId");
        Part filePart = request.getPart("productImage");

        // VALIDATION SERVER-SIDE
        if (bookTitle == null || bookTitle.trim().isEmpty()) {
            request.setAttribute("message", "Tên sách không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (author == null || author.trim().isEmpty()) {
            request.setAttribute("message", "Tác giả không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (publisher == null || publisher.trim().isEmpty()) {
            request.setAttribute("message", "Nhà xuất bản không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (priceParam == null || priceParam.trim().isEmpty()) {
            request.setAttribute("message", "Giá không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (stockParam == null || stockParam.trim().isEmpty()) {
            request.setAttribute("message", "Tồn kho không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            request.setAttribute("message", "Vui lòng chọn danh mục!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }

        BigDecimal price = new BigDecimal(priceParam);
        int stockQuantity = Integer.parseInt(stockParam);
        int categoryId = Integer.parseInt(categoryIdParam);

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            if (idParam == null || idParam.trim().isEmpty()) {
                // THÊM MỚI
                if (filePart == null || filePart.getSize() == 0) {
                    request.setAttribute("message", "Vui lòng chọn ảnh sản phẩm!");
                    request.setAttribute("messageType", "error");
                    request.setAttribute("formData", request.getParameterMap());
                    em.close();
                    doGet(request, response);
                    return;
                }

                String imagePath = uploadImage(request, filePart);
                
                Category category = em.find(Category.class, categoryId);
                Product product = new Product();
                product.setBookTitle(bookTitle);
                product.setAuthor(author);
                product.setPublisher(publisher);
                product.setPrice(price);
                product.setStockQuantity(stockQuantity);
                product.setDescription(description);
                product.setImagePath(imagePath);
                product.setCategory(category);
                
                em.persist(product);
                session.setAttribute("message", "Thêm sản phẩm thành công!");
            } else {
                // CẬP NHẬT
                int id = Integer.parseInt(idParam);
                
                String imagePath = null;
                if (filePart != null && filePart.getSize() > 0) {
                    imagePath = uploadImage(request, filePart);
                }
                
                if (imagePath != null) {
                    em.createNativeQuery(
                        "UPDATE Products SET BookTitle = :title, Author = :author, Publisher = :publisher, " +
                        "Price = :price, StockQuantity = :stock, Description = :desc, ImagePath = :image, CategoryId = :categoryId " +
                        "WHERE Id = :id")
                        .setParameter("title", bookTitle)
                        .setParameter("author", author)
                        .setParameter("publisher", publisher)
                        .setParameter("price", price)
                        .setParameter("stock", stockQuantity)
                        .setParameter("desc", description)
                        .setParameter("image", imagePath)
                        .setParameter("categoryId", categoryId)
                        .setParameter("id", id)
                        .executeUpdate();
                } else {
                    em.createNativeQuery(
                        "UPDATE Products SET BookTitle = :title, Author = :author, Publisher = :publisher, " +
                        "Price = :price, StockQuantity = :stock, Description = :desc, CategoryId = :categoryId " +
                        "WHERE Id = :id")
                        .setParameter("title", bookTitle)
                        .setParameter("author", author)
                        .setParameter("publisher", publisher)
                        .setParameter("price", price)
                        .setParameter("stock", stockQuantity)
                        .setParameter("desc", description)
                        .setParameter("categoryId", categoryId)
                        .setParameter("id", id)
                        .executeUpdate();
                }
                
                session.setAttribute("message", "Cập nhật sản phẩm thành công!");
            }

            tx.commit();
            session.setAttribute("messageType", "success");

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
            request.setAttribute("message", "Lỗi: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            em.close();
            doGet(request, response);
            return;
        } finally {
            em.close();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private String uploadImage(HttpServletRequest request, Part filePart) throws IOException {
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String filePath = uploadPath + File.separator + uniqueFileName;
        
        filePart.write(filePath);
        
        return "/" + UPLOAD_DIR + "/" + uniqueFileName;
    }
}
