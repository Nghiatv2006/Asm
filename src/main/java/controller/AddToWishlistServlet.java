package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.persistence.*;
import model.*;
import utils.JpaUtil;

@WebServlet("/add-to-wishlist")
public class AddToWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Bạn cần đăng nhập!\"}");
            return;
        }

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
            return;
        }
        int productId = Integer.parseInt(productIdParam);

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            // Check trùng
            TypedQuery<ProductWishlist> checkQuery = em.createQuery(
                "SELECT w FROM ProductWishlist w WHERE w.user.id = :uid AND w.product.id = :pid", ProductWishlist.class);
            checkQuery.setParameter("uid", user.getId());
            checkQuery.setParameter("pid", productId);

            boolean existed = false;
            try {
                checkQuery.getSingleResult();
                existed = true;
            } catch (NoResultException ignore) {}

            if (existed) {
                tx.rollback();
                response.getWriter().write("{\"success\": false, \"message\": \"Đã tồn tại trong mục yêu thích!\"}");
                return;
            }

            // Thêm mới
            Product product = em.find(Product.class, productId);
            ProductWishlist wishlist = new ProductWishlist();
            wishlist.setUser(user);
            wishlist.setProduct(product);

            em.persist(wishlist);
            tx.commit();

            response.getWriter().write("{\"success\": true, \"message\": \"Đã thêm vào yêu thích!\"}");
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        } finally {
            em.close();
        }
    }
}
