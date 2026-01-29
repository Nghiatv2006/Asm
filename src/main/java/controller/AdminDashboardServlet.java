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
import java.util.LinkedHashMap;
import jakarta.persistence.EntityManager;
import model.*;
import utils.JpaUtil;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminDashboardServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

//        if (user == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }

        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();

        try {
            // ====== THỐNG KÊ CƠ BẢN ======
            Long totalUsers = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
            Long totalCategories = em.createQuery("SELECT COUNT(c) FROM Category c", Long.class).getSingleResult();
            Long totalProducts = em.createQuery("SELECT COUNT(p) FROM Product p", Long.class).getSingleResult();
            Long totalOrders = em.createQuery("SELECT COUNT(o) FROM Order o", Long.class).getSingleResult();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("adminName", user.getFullName() != null ? user.getFullName() : user.getUsername());

         // ====== 1. ĐƠN HÀNG 7 NGÀY GẦN ĐÂY ======
            List<Order> allOrders = em.createQuery(
                "SELECT o FROM Order o " +
                "WHERE o.status = 'COMPLETED' " +
                "ORDER BY o.orderDate ASC", Order.class) // ĐỔI THÀNH ASC
                .setMaxResults(100)
                .getResultList();

            // Group theo ngày bằng Java
            Map<String, Long> ordersChartData = new LinkedHashMap<>();
            java.time.LocalDateTime sevenDaysAgo = java.time.LocalDateTime.now().minusDays(7);

            for (Order order : allOrders) {
                if (order.getOrderDate().isAfter(sevenDaysAgo)) {
                    String date = order.getOrderDate().toLocalDate().toString();
                    ordersChartData.put(date, ordersChartData.getOrDefault(date, 0L) + 1);
                }
            }
            request.setAttribute("ordersChartData", ordersChartData);



            // ====== 2. PHÂN BỐ SẢN PHẨM THEO DANH MỤC (PIE CHART) ======
            List<Object[]> categoryDistribution = em.createQuery(
                "SELECT c.categoryName, COUNT(p) " +
                "FROM Product p JOIN p.category c " +
                "GROUP BY c.categoryName", Object[].class)
                .getResultList();
            
            Map<String, Long> categoryChartData = new LinkedHashMap<>();
            for (Object[] row : categoryDistribution) {
                categoryChartData.put((String) row[0], ((Number) row[1]).longValue());
            }
            request.setAttribute("categoryChartData", categoryChartData);

            // ====== 3. TOP 5 SẢN PHẨM ĐƯỢC XEM NHIỀU NHẤT (BAR CHART) ======
            List<Object[]> topViewedProducts = em.createQuery(
                "SELECT p.bookTitle, p.viewCount " +
                "FROM Product p " +
                "ORDER BY p.viewCount DESC", Object[].class)
                .setMaxResults(5)
                .getResultList();
            
            Map<String, Integer> viewsChartData = new LinkedHashMap<>();
            for (Object[] row : topViewedProducts) {
                viewsChartData.put((String) row[0], ((Number) row[1]).intValue());
            }
            request.setAttribute("viewsChartData", viewsChartData);

            // ====== 4. ĐƠN HÀNG GẦN ĐÂY (5 đơn mới nhất) ======
            List<Order> recentOrders = em.createQuery(
                "SELECT o FROM Order o " +
                "ORDER BY o.orderDate DESC", Order.class)
                .setMaxResults(5)
                .getResultList();
            request.setAttribute("recentOrders", recentOrders);

         // ====== 5. NGƯỜI DÙNG MỚI (5 user mới nhất) ======
            List<User> newUsers = em.createQuery(
                "SELECT u FROM User u " +
                "WHERE u.role = 'USER' " +
                "ORDER BY u.createdDate DESC", User.class)
                .setMaxResults(5)
                .getResultList();

            // DEBUG: In ra console để kiểm tra
            System.out.println("========== NGƯỜI DÙNG MỚI ==========");
            for (User u : newUsers) {
                System.out.println("Username: " + u.getUsername() + " | Created: " + u.getCreatedDate());
            }

            request.setAttribute("newUsers", newUsers);


            // ====== 6. TOP 3 SẢN PHẨM BÁN CHẠY ======
            List<Object[]> topSellingProducts = em.createQuery(
                "SELECT p.bookTitle, c.categoryName, COUNT(od), p.stockQuantity " +
                "FROM OrderDetail od JOIN Product p ON od.bookTitle = p.bookTitle " +
                "JOIN p.category c " +
                "GROUP BY p.bookTitle, c.categoryName, p.stockQuantity " +
                "ORDER BY COUNT(od) DESC", Object[].class)
                .setMaxResults(3)
                .getResultList();
            request.setAttribute("topSellingProducts", topSellingProducts);

            request.getRequestDispatcher("/views/admin-dashboard.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
