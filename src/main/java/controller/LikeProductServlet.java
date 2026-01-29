package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import model.Product;
import model.ProductInteraction;
import utils.JpaUtil;

@WebServlet("/like-product")
public class LikeProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public LikeProductServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        String productIdParam = request.getParameter("productId");
        String action = request.getParameter("action");
        
        if (productIdParam == null || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin\"}");
            return;
        }
        
        int productId = Integer.parseInt(productIdParam);
        
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            
            // Tìm product bằng JPQL
            TypedQuery<Product> productQuery = em.createQuery(
                "SELECT p FROM Product p WHERE p.id = :id", Product.class);
            productQuery.setParameter("id", productId);
            Product product = productQuery.getSingleResult();
            
            if (product == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
                return;
            }
            
            // LẤY COUNT BAN ĐẦU
            int newLikeCount = product.getLikeCount();
            int newDislikeCount = product.getDislikeCount();
            
            // Kiểm tra interaction bằng JPQL
            String jpql = "SELECT pi FROM ProductInteraction pi WHERE pi.userId = :userId AND pi.productId = :productId";
            TypedQuery<ProductInteraction> query = em.createQuery(jpql, ProductInteraction.class);
            query.setParameter("userId", userId);
            query.setParameter("productId", productId);
            
            ProductInteraction existingInteraction = null;
            try {
                existingInteraction = query.getSingleResult();
            } catch (NoResultException e) {
                // Chưa có interaction
            }
            
            String message = "";
            String currentAction = "";
            
            if (existingInteraction == null) {
                // THÊM MỚI INTERACTION
                ProductInteraction newInteraction = new ProductInteraction(userId, productId, action.toUpperCase());
                em.persist(newInteraction);
                
                // CẬP NHẬT LIKE/DISLIKE COUNT BẰNG JPQL
                if ("like".equals(action)) {
                    Query updateQuery = em.createQuery(
                        "UPDATE Product p SET p.likeCount = p.likeCount + 1 WHERE p.id = :id");
                    updateQuery.setParameter("id", productId);
                    updateQuery.executeUpdate();
                    newLikeCount++; // TÍNH TOÁN COUNT MỚI
                    message = "Đã thích!";
                    currentAction = "LIKE";
                } else {
                    Query updateQuery = em.createQuery(
                        "UPDATE Product p SET p.dislikeCount = p.dislikeCount + 1 WHERE p.id = :id");
                    updateQuery.setParameter("id", productId);
                    updateQuery.executeUpdate();
                    newDislikeCount++; // TÍNH TOÁN COUNT MỚI
                    message = "Đã đánh giá!";
                    currentAction = "DISLIKE";
                }
                
            } else {
                String previousAction = existingInteraction.getActionType();
                
                if (previousAction.equalsIgnoreCase(action)) {
                    // BỎ REACT - XÓA INTERACTION BẰNG JPQL
                    Query deleteQuery = em.createQuery(
                        "DELETE FROM ProductInteraction pi WHERE pi.userId = :userId AND pi.productId = :productId");
                    deleteQuery.setParameter("userId", userId);
                    deleteQuery.setParameter("productId", productId);
                    deleteQuery.executeUpdate();
                    
                    // GIẢM COUNT BẰNG JPQL
                    if ("like".equals(action)) {
                        Query updateQuery = em.createQuery(
                            "UPDATE Product p SET p.likeCount = p.likeCount - 1 WHERE p.id = :id");
                        updateQuery.setParameter("id", productId);
                        updateQuery.executeUpdate();
                        newLikeCount--; // TÍNH TOÁN COUNT MỚI
                        message = "Đã bỏ thích!";
                    } else {
                        Query updateQuery = em.createQuery(
                            "UPDATE Product p SET p.dislikeCount = p.dislikeCount - 1 WHERE p.id = :id");
                        updateQuery.setParameter("id", productId);
                        updateQuery.executeUpdate();
                        newDislikeCount--; // TÍNH TOÁN COUNT MỚI
                        message = "Đã bỏ đánh giá!";
                    }
                    currentAction = "";
                    
                } else {
                    tx.rollback();
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: Không thể thực hiện hành động này\"}");
                    return;
                }
            }
            
            tx.commit();
            
            // TRẢ VỀ COUNT ĐÃ TÍNH TOÁN (KHÔNG CẦN SELECT LẠI)
            String jsonResponse = String.format(
                "{\"success\": true, \"message\": \"%s\", \"likeCount\": %d, \"dislikeCount\": %d, \"currentAction\": \"%s\"}", 
                message,
                newLikeCount, 
                newDislikeCount,
                currentAction
            );
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống: " + e.getMessage() + "\"}");
        } finally {
            em.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
