package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.User;
import utils.JpaUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirectParam = request.getParameter("redirect");
        if (redirectParam != null && !redirectParam.trim().isEmpty()) {
            request.setAttribute("redirectParam", redirectParam);
        }
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String redirectParam = request.getParameter("redirect");

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username không được để trống!");
            if (redirectParam != null) {
                request.setAttribute("redirectParam", redirectParam);
            }
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Mật khẩu không được để trống!");
            if (redirectParam != null) {
                request.setAttribute("redirectParam", redirectParam);
            }
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();

        try {
            String jpql = "SELECT u FROM User u WHERE u.username = :username";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);

            User user = query.getSingleResult();

            if (user.getPassword().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user); // ĐÚNG KEY DUY NHẤT
                session.setAttribute("userId", user.getId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("fullName", user.getFullName());

                String redirectUrl;
                if (redirectParam != null && !redirectParam.trim().isEmpty()) {
                    redirectUrl = redirectParam;
                } else {
                    if ("ADMIN".equals(user.getRole())) {
                        redirectUrl = request.getContextPath() + "/admin/dashboard";
                    } else {
                        redirectUrl = request.getContextPath() + "/home";
                    }
                }

                session.setAttribute("loginSuccess", true);
                session.setAttribute("redirectUrl", redirectUrl);
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);

            } else {
                request.setAttribute("errorMessage", "Sai mật khẩu!");
                if (redirectParam != null) {
                    request.setAttribute("redirectParam", redirectParam);
                }
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } catch (NoResultException e) {
            request.setAttribute("errorMessage", "Tài khoản không tồn tại!");
            if (redirectParam != null) {
                request.setAttribute("redirectParam", redirectParam);
            }
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            if (redirectParam != null) {
                request.setAttribute("redirectParam", redirectParam);
            }
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }
}
