package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Random;
import utils.EmailUtil;

@WebServlet("/send-otp")
public class SendOtpServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Email không được để trống!\"}");
            return;
        }
        
        if (!email.matches("^\\S+@\\S+\\.\\S+$")) {
            response.getWriter().write("{\"success\": false, \"message\": \"Email không hợp lệ!\"}");
            return;
        }
        
        try {
            // Tạo OTP 6 số
            String otp = String.format("%06d", new Random().nextInt(999999));
            
            // Lưu OTP vào session (hết hạn sau 5 phút)
            HttpSession session = request.getSession();
            session.setAttribute("registrationOtp", otp);
            session.setAttribute("otpExpiry", System.currentTimeMillis() + 300000); // 5 phút
            session.setAttribute("otpEmail", email);
            
            // Gửi email
            String subject = "Mã OTP xác minh đăng ký - Bookstore";
            String body = "<html><body style='font-family: Arial, sans-serif;'>"
                    + "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; text-align: center;'>"
                    + "<h2 style='color: white;'>Xác minh đăng ký tài khoản</h2>"
                    + "</div>"
                    + "<div style='padding: 20px;'>"
                    + "<p>Xin chào,</p>"
                    + "<p>Mã OTP của bạn để xác minh đăng ký tài khoản là:</p>"
                    + "<div style='background: #f0f0f0; padding: 15px; text-align: center; font-size: 28px; font-weight: bold; color: #667eea; letter-spacing: 5px;'>"
                    + otp
                    + "</div>"
                    + "<p style='color: #999; font-size: 14px;'>Mã OTP có hiệu lực trong 5 phút.</p>"
                    + "<p>Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email này.</p>"
                    + "<hr>"
                    + "<p style='color: #999; font-size: 12px;'>© 2025 Bookstore. All rights reserved.</p>"
                    + "</div>"
                    + "</body></html>";
            
            EmailUtil.sendEmail(email, subject, body);
            
            response.getWriter().write("{\"success\": true, \"message\": \"Mã OTP đã được gửi đến email của bạn!\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi gửi email: " + e.getMessage() + "\"}");
        }
    }
}
