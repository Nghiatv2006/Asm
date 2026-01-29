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
import model.User;
import utils.JpaUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RegisterServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// LẤY REDIRECT PARAM từ URL (nếu có)
		String redirectParam = request.getParameter("redirect");
		
		// TRUYỀN SANG JSP để giữ lại trong form
		if (redirectParam != null && !redirectParam.trim().isEmpty()) {
			request.setAttribute("redirectParam", redirectParam);
		}
		
		// Hiển thị trang đăng ký
		request.getRequestDispatcher("/views/register.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    
	    // Lấy dữ liệu từ form
	    String username = request.getParameter("username");
	    String email = request.getParameter("email");
	    String password = request.getParameter("password");
	    String fullName = request.getParameter("fullName");
	    String phone = request.getParameter("phone");
	    String address = request.getParameter("address");
	    String redirectParam = request.getParameter("redirect");
	    
	    HttpSession session = request.getSession();
	    
	    EntityManager em = JpaUtil.getEntityManager();
	    EntityTransaction tx = em.getTransaction();
	    
	    try {
	        // VALIDATION BACKEND
	        if (username == null || username.trim().isEmpty()) {
	            throw new Exception("Username không được để trống!");
	        }
	        if (password == null || password.trim().isEmpty()) {
	            throw new Exception("Mật khẩu không được để trống!");
	        }
	        if (fullName == null || fullName.trim().isEmpty()) {
	            throw new Exception("Họ và tên không được để trống!");
	        }
	        if (email == null || email.trim().isEmpty()) {
	            throw new Exception("Email không được để trống!");
	        }
	        
	        // KIỂM TRA EMAIL ĐÃ VERIFY CHƯA
	        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
	        String verifiedEmail = (String) session.getAttribute("verifiedEmail");
	        
	        if (emailVerified == null || !emailVerified) {
	            throw new Exception("Vui lòng xác minh email trước khi đăng ký!");
	        }
	        
	        if (!email.equals(verifiedEmail)) {
	            throw new Exception("Email đã thay đổi! Vui lòng xác minh lại.");
	        }
	        
	        // CHECK USERNAME TRÙNG
	        String jpql = "SELECT COUNT(u) FROM User u WHERE u.username = :username";
	        Long count = em.createQuery(jpql, Long.class)
	                .setParameter("username", username)
	                .getSingleResult();
	        
	        if (count > 0) {
	            throw new Exception("Username đã tồn tại! Vui lòng chọn username khác.");
	        }
	        
	        // Tạo User mới
	        tx.begin();
	        
	        User user = new User();
	        user.setUsername(username);
	        user.setEmail(email);
	        user.setPassword(password);
	        user.setFullName(fullName);
	        user.setPhone(phone);
	        user.setAddress(address);
	        user.setRole("USER");
	        
	        // ===== THÊM DÒNG NÀY ĐỂ SET NGÀY TẠO =====
	        user.setCreatedDate(java.time.LocalDateTime.now());
	        // ==========================================
	        
	        em.persist(user);
	        tx.commit();
	        
	        // Xóa session OTP
	        session.removeAttribute("emailVerified");
	        session.removeAttribute("verifiedEmail");
	        session.removeAttribute("otpEmail");
	        
	        // TỰ ĐỘNG ĐĂNG NHẬP
	        session.setAttribute("loggedInUser", user);
	        session.setAttribute("userId", user.getId());
	        session.setAttribute("username", user.getUsername());
	        session.setAttribute("role", user.getRole());
	        
	        // XÁC ĐỊNH URL REDIRECT
	        String redirectUrl;
	        if (redirectParam != null && !redirectParam.trim().isEmpty()) {
	            redirectUrl = redirectParam;
	        } else {
	            redirectUrl = request.getContextPath() + "/home";
	        }
	        
	        // FORWARD về register.jsp để hiển thị popup thành công
	        request.setAttribute("registerSuccess", "true");
	        request.setAttribute("redirectUrl", redirectUrl);
	        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
	        
	    } catch (Exception e) {
	        if (tx != null && tx.isActive()) {
	            tx.rollback();
	        }
	        
	        // LƯU LẠI DỮ LIỆU (trừ password)
	        request.setAttribute("errorMessage", e.getMessage());
	        request.setAttribute("username", username);
	        request.setAttribute("email", email);
	        request.setAttribute("fullName", fullName);
	        request.setAttribute("phone", phone);
	        request.setAttribute("address", address);
	        
	        // GIỮ LẠI REDIRECT PARAM
	        if (redirectParam != null && !redirectParam.trim().isEmpty()) {
	            request.setAttribute("redirectParam", redirectParam);
	        }
	        
	        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
	    } finally {
	        em.close();
	    }
	}

}
