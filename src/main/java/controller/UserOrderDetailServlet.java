package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.persistence.*;
import model.Order;
import model.OrderDetail;
import model.User;
import utils.JpaUtil;

@WebServlet("/user-order-detail")
public class UserOrderDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("profile");
            return;
        }
        
        int orderId;
        try {
            orderId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("profile");
            return;
        }
        
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // Lấy đơn hàng + kiểm tra quyền sở hữu
            TypedQuery<Order> orderQuery = em.createQuery(
                "SELECT o FROM Order o JOIN FETCH o.user WHERE o.id = :id", Order.class);
            orderQuery.setParameter("id", orderId);
            
            Order order = null;
            try {
                order = orderQuery.getSingleResult();
            } catch (NoResultException e) {
                response.sendRedirect("profile");
                return;
            }
            
            // Kiểm tra xem đơn hàng có phải của user hiện tại không
            if (!order.getUser().getId().equals(user.getId())) {
                response.sendRedirect("profile");
                return;
            }
            
            // Lấy chi tiết đơn hàng
            TypedQuery<OrderDetail> detailQuery = em.createQuery(
                "SELECT od FROM OrderDetail od WHERE od.order.id = :orderId", OrderDetail.class);
            detailQuery.setParameter("orderId", orderId);
            List<OrderDetail> orderDetails = detailQuery.getResultList();
            
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("/views/user-order-detail.jsp").forward(request, response);
            
        } finally {
            em.close();
        }
    }
}
