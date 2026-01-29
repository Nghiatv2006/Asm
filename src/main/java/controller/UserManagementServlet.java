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
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import model.User;
import utils.JpaUtil;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserManagementServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // KIỂM TRA ĐĂNG NHẬP VÀ ROLE ADMIN
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
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                User user = em.find(User.class, id);
                request.setAttribute("user", user);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin();
                    Query query = em.createQuery("DELETE FROM User u WHERE u.id = :id");
                    query.setParameter("id", id);
                    int deletedCount = query.executeUpdate();
                    tx.commit();
                    
                    if (deletedCount > 0) {
                        request.setAttribute("message", "Xóa người dùng thành công!");
                        request.setAttribute("messageType", "success");
                    } else {
                        request.setAttribute("message", "Không tìm thấy người dùng!");
                        request.setAttribute("messageType", "error");
                    }
                } catch (Exception e) {
                    if (tx.isActive()) tx.rollback();
                    request.setAttribute("message", "Lỗi: Không thể xóa người dùng");
                    request.setAttribute("messageType", "error");
                }
            }

            // LOAD DANH SÁCH USERS BẰNG JPQL
            List<User> users = em.createQuery("SELECT u FROM User u ORDER BY u.id", User.class).getResultList();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/views/admin-users.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

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
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        // VALIDATION SERVER-SIDE
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("message", "Username không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("message", "Email không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("message", "Họ tên không được để trống!");
            request.setAttribute("messageType", "error");
            request.setAttribute("formData", request.getParameterMap());
            doGet(request, response);
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            // KIỂM TRA TRÙNG USERNAME BẰNG JPQL
            TypedQuery<User> checkQuery = em.createQuery(
                "SELECT u FROM User u WHERE u.username = :username", User.class);
            checkQuery.setParameter("username", username);
            
            User existingUser = null;
            try {
                existingUser = checkQuery.getSingleResult();
            } catch (NoResultException e) {
                // Không trùng - OK
            }
            
            // Nếu đang thêm mới và username đã tồn tại
            if ((idParam == null || idParam.trim().isEmpty()) && existingUser != null) {
                request.setAttribute("message", "Username đã tồn tại! Vui lòng chọn username khác.");
                request.setAttribute("messageType", "error");
                request.setAttribute("formData", request.getParameterMap());
                em.close();
                doGet(request, response);
                return;
            }
            
            // Nếu đang sửa và username trùng với user khác
            if (idParam != null && !idParam.trim().isEmpty()) {
                int id = Integer.parseInt(idParam);
                if (existingUser != null && existingUser.getId() != id) {
                    request.setAttribute("message", "Username đã tồn tại! Vui lòng chọn username khác.");
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
                if (password == null || password.trim().isEmpty()) {
                    request.setAttribute("message", "Mật khẩu không được để trống khi thêm mới!");
                    request.setAttribute("messageType", "error");
                    request.setAttribute("formData", request.getParameterMap());
                    em.close();
                    doGet(request, response);
                    return;
                }
                
                User user = new User();
                user.setUsername(username);
                user.setEmail(email);
                user.setPassword(password);
                user.setFullName(fullName);
                user.setPhone(phone);
                user.setAddress(address);
                user.setRole(role);
                
             // ===== THÊM DÒNG NÀY =====
                user.setCreatedDate(java.time.LocalDateTime.now());
                // =========================
                
                em.persist(user);
                session.setAttribute("message", "Thêm người dùng thành công!");
            } else {
                // CẬP NHẬT BẰNG JPQL
                int id = Integer.parseInt(idParam);
                
                // Cập nhật tất cả trường (trừ password nếu để trống)
                if (password != null && !password.trim().isEmpty()) {
                    // Cập nhật kể cả password
                    Query updateQuery = em.createQuery(
                        "UPDATE User u SET u.username = :username, u.email = :email, u.password = :password, " +
                        "u.fullName = :fullName, u.phone = :phone, u.address = :address, u.role = :role " +
                        "WHERE u.id = :id");
                    updateQuery.setParameter("username", username);
                    updateQuery.setParameter("email", email);
                    updateQuery.setParameter("password", password);
                    updateQuery.setParameter("fullName", fullName);
                    updateQuery.setParameter("phone", phone);
                    updateQuery.setParameter("address", address);
                    updateQuery.setParameter("role", role);
                    updateQuery.setParameter("id", id);
                    int updatedCount = updateQuery.executeUpdate();
                    
                    if (updatedCount == 0) {
                        request.setAttribute("message", "Không tìm thấy người dùng!");
                        request.setAttribute("messageType", "error");
                        em.close();
                        doGet(request, response);
                        return;
                    }
                } else {
                    // Cập nhật không đổi password
                    Query updateQuery = em.createQuery(
                        "UPDATE User u SET u.username = :username, u.email = :email, " +
                        "u.fullName = :fullName, u.phone = :phone, u.address = :address, u.role = :role " +
                        "WHERE u.id = :id");
                    updateQuery.setParameter("username", username);
                    updateQuery.setParameter("email", email);
                    updateQuery.setParameter("fullName", fullName);
                    updateQuery.setParameter("phone", phone);
                    updateQuery.setParameter("address", address);
                    updateQuery.setParameter("role", role);
                    updateQuery.setParameter("id", id);
                    int updatedCount = updateQuery.executeUpdate();
                    
                    if (updatedCount == 0) {
                        request.setAttribute("message", "Không tìm thấy người dùng!");
                        request.setAttribute("messageType", "error");
                        em.close();
                        doGet(request, response);
                        return;
                    }
                }
                
                session.setAttribute("message", "Cập nhật người dùng thành công!");
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

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
