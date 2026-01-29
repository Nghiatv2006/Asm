package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import model.Category;
import utils.JpaUtil;

@WebServlet("/admin/categories")
public class CategoryManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CategoryManagementServlet() {
        super();
    }

    @Override
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

        // BỎ ĐOẠN NÀY ĐI - ĐỂ JSP TỰ XÓA
        // String flashMsg = (String) session.getAttribute("message");
        // String flashType = (String) session.getAttribute("messageType");
        // if (flashMsg != null) {
        //     request.setAttribute("message", flashMsg);
        //     request.setAttribute("messageType", flashType);
        //     session.removeAttribute("message");
        //     session.removeAttribute("messageType");
        // }

        String action = request.getParameter("action");
        EntityManager em = JpaUtil.getEntityManager();

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Category category = em.find(Category.class, id);
                request.setAttribute("category", category);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin();
                    
                    // KIỂM TRA XEM CÓ SẢN PHẨM TRONG DANH MỤC KHÔNG
                    Long productCount = em.createQuery(
                        "SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId", Long.class)
                        .setParameter("categoryId", id)
                        .getSingleResult();
                    
                    if (productCount > 0) {
                        // CÓ SẢN PHẨM → KHÔNG CHO XÓA
                        session.setAttribute("message", "Không thể xóa danh mục này vì có " + productCount + " sản phẩm đang sử dụng!");
                        session.setAttribute("messageType", "error");
                        tx.rollback();
                    } else {
                        // KHÔNG CÓ SẢN PHẨM → CHO XÓA
                        Query query = em.createQuery("DELETE FROM Category c WHERE c.id = :id");
                        query.setParameter("id", id);
                        int deletedCount = query.executeUpdate();
                        tx.commit();

                        if (deletedCount > 0) {
                            session.setAttribute("message", "Xóa danh mục thành công!");
                            session.setAttribute("messageType", "success");
                        } else {
                            session.setAttribute("message", "Không tìm thấy danh mục!");
                            session.setAttribute("messageType", "error");
                        }
                    }
                } catch (Exception e) {
                    if (tx.isActive()) tx.rollback();
                    e.printStackTrace();
                    session.setAttribute("message", "Lỗi: " + e.getMessage());
                    session.setAttribute("messageType", "error");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                return;
            }


            // DANH SÁCH CATEGORY
            List<Category> categories = em.createQuery(
                "SELECT c FROM Category c ORDER BY c.id", Category.class
            ).getResultList();

            // ĐẾM SỐ SẢN PHẨM MỖI CATEGORY
            List<Object[]> counts = em.createQuery(
                "SELECT c.id, COUNT(p) FROM Category c LEFT JOIN c.products p GROUP BY c.id",
                Object[].class
            ).getResultList();
            Map<Integer, Long> categoryProductCount = new HashMap<>();
            for (Object[] row : counts) {
                categoryProductCount.put((Integer) row[0], (Long) row[1]);
            }

            request.setAttribute("categories", categories);
            request.setAttribute("categoryProductCount", categoryProductCount);

            request.getRequestDispatcher("/views/admin-categories.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }



    @Override
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
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");

        // VALIDATION CƠ BẢN
        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.setAttribute("message", "Tên danh mục không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            // CHECK TRÙNG TÊN DANH MỤC
            jakarta.persistence.TypedQuery<Category> checkQuery = em.createQuery(
                "SELECT c FROM Category c WHERE c.categoryName = :name", Category.class);
            checkQuery.setParameter("name", categoryName);

            Category existed = null;
            try {
                existed = checkQuery.getSingleResult();
            } catch (jakarta.persistence.NoResultException e) {
                // không trùng
            }

            // Thêm mới: nếu đã tồn tại tên → lỗi
            if ((idParam == null || idParam.trim().isEmpty()) && existed != null) {
                request.setAttribute("message", "Tên danh mục đã tồn tại! Vui lòng chọn tên khác.");
                request.setAttribute("messageType", "error");
                request.setAttribute("formData", request.getParameterMap());
                em.close();
                doGet(request, response);
                return;
            }

            // Sửa: nếu tồn tại category khác có cùng tên
            if (idParam != null && !idParam.trim().isEmpty() && existed != null) {
                int id = Integer.parseInt(idParam);
                if (!existed.getId().equals(id)) {
                    request.setAttribute("message", "Tên danh mục đã tồn tại! Vui lòng chọn tên khác.");
                    request.setAttribute("messageType", "error");
                    request.setAttribute("formData", request.getParameterMap());
                    em.close();
                    doGet(request, response);
                    return;
                }
            }

            tx.begin();

            if (idParam == null || idParam.trim().isEmpty()) {
                // THÊM MỚI
                Category category = new Category();
                category.setCategoryName(categoryName);
                category.setDescription(description);
                em.persist(category);
                session.setAttribute("message", "Thêm danh mục thành công!");
            } else {
                // CẬP NHẬT
                int id = Integer.parseInt(idParam);
                Query query = em.createQuery(
                    "UPDATE Category c SET c.categoryName = :name, c.description = :desc WHERE c.id = :id");
                query.setParameter("name", categoryName);
                query.setParameter("desc", description);
                query.setParameter("id", id);
                int updatedCount = query.executeUpdate();

                if (updatedCount > 0) {
                    session.setAttribute("message", "Cập nhật danh mục thành công!");
                } else {
                    session.setAttribute("message", "Không tìm thấy danh mục!");
                }
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

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
