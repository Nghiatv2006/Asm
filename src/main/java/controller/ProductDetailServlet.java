package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import model.Product;
import utils.JpaUtil;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public ProductDetailServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdParam = request.getParameter("id");
        
        if (productIdParam == null || productIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int productId = Integer.parseInt(productIdParam);
        
        EntityManager em = JpaUtil.getEntityManager();
        
        try {
            // Lấy thông tin sản phẩm bằng JPQL
            TypedQuery<Product> productQuery = em.createQuery(
                "SELECT p FROM Product p WHERE p.id = :id", Product.class);
            productQuery.setParameter("id", productId);
            Product product = productQuery.getSingleResult();
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // TĂNG VIEW COUNT BẰNG JPQL UPDATE
            EntityTransaction tx = em.getTransaction();
            tx.begin();
            Query updateQuery = em.createQuery(
                "UPDATE Product p SET p.viewCount = p.viewCount + 1 WHERE p.id = :id");
            updateQuery.setParameter("id", productId);
            updateQuery.executeUpdate();
            tx.commit();
            
            // Refresh product để lấy viewCount mới
            em.refresh(product);
            
            // Lấy sản phẩm liên quan bằng JPQL
            String jpqlRelated = "SELECT p FROM Product p WHERE p.category.id = :categoryId AND p.id != :productId ORDER BY p.createdDate DESC";
            TypedQuery<Product> relatedQuery = em.createQuery(jpqlRelated, Product.class);
            relatedQuery.setParameter("categoryId", product.getCategory().getId());
            relatedQuery.setParameter("productId", productId);
            relatedQuery.setMaxResults(3);
            List<Product> relatedProducts = relatedQuery.getResultList();
            
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            
            request.getRequestDispatcher("/views/product-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
