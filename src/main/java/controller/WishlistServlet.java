package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.persistence.*;
import model.ProductWishlist;
import model.User;
import utils.JpaUtil;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.sendRedirect("login?redirect=" + request.getRequestURI());
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<ProductWishlist> wishList = em.createQuery(
                    "SELECT w FROM ProductWishlist w JOIN FETCH w.product WHERE w.user.id = :uid", ProductWishlist.class)
                    .setParameter("uid", user.getId())
                    .getResultList();

            // Nếu có message (báo xóa), hiển thị ra
            String msg = (String) session.getAttribute("wishlistMsg");
            if (msg != null) {
                request.setAttribute("wishlistMsg", msg);
                session.removeAttribute("wishlistMsg");
            }

            request.setAttribute("wishList", wishList);
            request.getRequestDispatcher("/views/user-wishlist.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String productIdStr = request.getParameter("productId");
        if (productIdStr != null) {
            int productId = Integer.parseInt(productIdStr);
            EntityManager em = JpaUtil.getEntityManager();
            EntityTransaction tx = em.getTransaction();

            try {
                tx.begin();
                Query del = em.createQuery("DELETE FROM ProductWishlist w WHERE w.user.id = :uid AND w.product.id = :pid");
                del.setParameter("uid", user.getId());
                del.setParameter("pid", productId);
                int result = del.executeUpdate();
                tx.commit();
                session.setAttribute("wishlistMsg", (result > 0) ? "Đã xóa khỏi yêu thích." : "Không tìm thấy sản phẩm!");
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                session.setAttribute("wishlistMsg", "Lỗi xóa sản phẩm: " + e.getMessage());
            } finally {
                em.close();
            }
        }

        response.sendRedirect("wishlist");
    }
}
