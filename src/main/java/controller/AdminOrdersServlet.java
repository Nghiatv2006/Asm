package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Order;
import model.OrderDetail;
import utils.JpaUtil;

@WebServlet("/admin/orders")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminOrdersServlet() {
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

        String action = request.getParameter("action");
        EntityManager em = JpaUtil.getEntityManager();

        try {
            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                // Lấy 1 order + user bằng JPQL
                TypedQuery<Order> orderQuery = em.createQuery(
                    "SELECT o FROM Order o JOIN FETCH o.user WHERE o.id = :id", Order.class);
                orderQuery.setParameter("id", id);
                Order order = orderQuery.getSingleResult();

                // Lấy danh sách OrderDetails
                TypedQuery<OrderDetail> detailQuery = em.createQuery(
                    "SELECT od FROM OrderDetail od WHERE od.order.id = :orderId", OrderDetail.class);
                detailQuery.setParameter("orderId", id);
                List<OrderDetail> orderDetails = detailQuery.getResultList();

                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.getRequestDispatcher("/views/admin-order-detail.jsp").forward(request, response);
                return;
            }

            // MẶC ĐỊNH: danh sách tất cả orders
            TypedQuery<Order> listQuery = em.createQuery(
                "SELECT o FROM Order o JOIN FETCH o.user ORDER BY o.orderDate DESC", Order.class);
            List<Order> orders = listQuery.getResultList();

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/views/admin-orders.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Không có sửa/xóa nên chỉ GET
    }
}
