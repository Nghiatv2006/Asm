package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.persistence.*;
import model.*;
import utils.JpaUtil;

@WebServlet("/order-from-wishlist")
public class OrderFromWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null) {
            response.sendRedirect("wishlist");
            return;
        }
        int productId = Integer.parseInt(productIdStr);

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();
            if ("delete".equals(action)) {
                // *** Xóa sản phẩm khỏi wishlist ***
                Query del = em.createQuery("DELETE FROM ProductWishlist w WHERE w.user.id = :uid AND w.product.id = :pid");
                del.setParameter("uid", user.getId());
                del.setParameter("pid", productId);
                int deleted = del.executeUpdate();
                tx.commit();
                if (deleted > 0) {
                    session.setAttribute("message", "Đã xóa khỏi yêu thích.");
                } else {
                    session.setAttribute("message", "Không tìm thấy sản phẩm!");
                }
                response.sendRedirect("wishlist");
                return;
            }

            // ĐẶT HÀNG TỪ WISHLIST
            // 1. Tạo Order mới
            Order order = new Order();
            order.setOrderDate(java.time.LocalDateTime.now());
            order.setStatus("PENDING");
            order.setUser(user);
            order.setShippingAddress("Chưa xác định"); // demo
            em.persist(order);

            // 2. Thêm OrderDetail
            Product product = em.find(Product.class, productId);
            OrderDetail detail = new OrderDetail();
            detail.setOrder(order);
            detail.setBookTitle(product.getBookTitle());
            detail.setProductImage(product.getImagePath());
            detail.setProductPrice(product.getPrice());
            detail.setQuantity(1);
            em.persist(detail);

            // 3. Tính tổng tiền
            order.setTotalAmount(product.getPrice());
            em.merge(order);

            // 4. Xóa khỏi Wishlist luôn
            Query del = em.createQuery("DELETE FROM ProductWishlist w WHERE w.user.id = :uid AND w.product.id = :pid");
            del.setParameter("uid", user.getId());
            del.setParameter("pid", productId);
            del.executeUpdate();

            tx.commit();
            session.setAttribute("message", "Đặt hàng thành công!");

        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            session.setAttribute("message", "Lỗi đặt hàng: " + e.getMessage());
        } finally {
            em.close();
        }

        response.sendRedirect("wishlist");
    }
}
