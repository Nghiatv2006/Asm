package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.persistence.*;
import model.Order;
import model.User;
import utils.JpaUtil;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // Lấy thông tin user mới nhất từ DB
            User currentUser = em.find(User.class, user.getId());
            
            // Lấy lịch sử đơn hàng của user
            TypedQuery<Order> orderQuery = em.createQuery(
                "SELECT o FROM Order o WHERE o.user.id = :uid ORDER BY o.orderDate DESC", Order.class);
            orderQuery.setParameter("uid", user.getId());
            List<Order> orders = orderQuery.getResultList();
            
            request.setAttribute("user", currentUser);
            request.setAttribute("orders", orders);
            
            request.getRequestDispatcher("/views/user-profile.jsp").forward(request, response);
            
        } finally {
            em.close();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            
            User currentUser = em.find(User.class, user.getId());
            currentUser.setFullName(fullname);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setAddress(address);
            
            em.merge(currentUser);
            tx.commit();
            
            // Cập nhật lại session
            session.setAttribute("loggedInUser", currentUser);
            
            session.setAttribute("profileMsg", "Cập nhật thông tin thành công!");
            response.sendRedirect("profile");
            
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            session.setAttribute("profileMsg", "Lỗi: " + e.getMessage());
            response.sendRedirect("profile");
        } finally {
            em.close();
        }
    }
}
