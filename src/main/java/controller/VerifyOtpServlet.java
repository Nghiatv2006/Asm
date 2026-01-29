package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        String inputOtp = request.getParameter("otp");
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Session không hợp lệ!\"}");
            return;
        }
        
        String savedOtp = (String) session.getAttribute("registrationOtp");
        Long otpExpiry = (Long) session.getAttribute("otpExpiry");
        String otpEmail = (String) session.getAttribute("otpEmail");
        
        // Kiểm tra OTP có tồn tại không
        if (savedOtp == null || otpExpiry == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng gửi mã OTP trước!\"}");
            return;
        }
        
        // Kiểm tra OTP hết hạn chưa
        if (System.currentTimeMillis() > otpExpiry) {
            session.removeAttribute("registrationOtp");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("otpEmail");
            response.getWriter().write("{\"success\": false, \"message\": \"Mã OTP đã hết hạn! Vui lòng gửi lại.\"}");
            return;
        }
        
        // Kiểm tra OTP có đúng không
        if (!savedOtp.equals(inputOtp)) {
            response.getWriter().write("{\"success\": false, \"message\": \"Mã OTP không đúng!\"}");
            return;
        }
        
        // OTP đúng → Lưu trạng thái đã verify
        session.setAttribute("emailVerified", true);
        session.setAttribute("verifiedEmail", otpEmail);
        
        // Xóa OTP khỏi session
        session.removeAttribute("registrationOtp");
        session.removeAttribute("otpExpiry");
        
        response.getWriter().write("{\"success\": true, \"message\": \"Xác minh thành công!\"}");
    }
}
