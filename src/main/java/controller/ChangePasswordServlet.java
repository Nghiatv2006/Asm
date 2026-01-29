package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.persistence.*;
import model.User;
import utils.JpaUtil;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            User currentUser = em.find(User.class, user.getId());
            
            // Kiểm tra mật khẩu cũ
            if (!currentUser.getPassword().equals(oldPassword)) {
                response.getWriter().write(
                    "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                    + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                    + "<script>Swal.fire({icon:'error',title:'Lỗi',text:'Mật khẩu cũ không đúng!',confirmButtonText:'OK'})"
                    + ".then(()=>{window.location='profile';});</script>"
                    + "</body></html>"
                );
                return;
            }
            
            // Kiểm tra mật khẩu mới khớp nhau
            if (!newPassword.equals(confirmPassword)) {
                response.getWriter().write(
                    "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                    + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                    + "<script>Swal.fire({icon:'error',title:'Lỗi',text:'Mật khẩu mới không khớp!',confirmButtonText:'OK'})"
                    + ".then(()=>{window.location='profile';});</script>"
                    + "</body></html>"
                );
                return;
            }
            
            // Kiểm tra độ dài mật khẩu
            if (newPassword.length() < 6) {
                response.getWriter().write(
                    "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                    + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                    + "<script>Swal.fire({icon:'error',title:'Lỗi',text:'Mật khẩu mới phải có ít nhất 6 ký tự!',confirmButtonText:'OK'})"
                    + ".then(()=>{window.location='profile';});</script>"
                    + "</body></html>"
                );
                return;
            }
            
            tx.begin();
            currentUser.setPassword(newPassword);
            em.merge(currentUser);
            tx.commit();
            
            // Thành công
            response.getWriter().write(
                "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                + "<script>Swal.fire({icon:'success',title:'Thành công',text:'Đổi mật khẩu thành công!',confirmButtonText:'OK'})"
                + ".then(()=>{window.location='profile';});</script>"
                + "</body></html>"
            );
            
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            response.getWriter().write(
                "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                + "<script>Swal.fire({icon:'error',title:'Lỗi',text:'Có lỗi xảy ra: " + e.getMessage() + "',confirmButtonText:'OK'})"
                + ".then(()=>{window.location='profile';});</script>"
                + "</body></html>"
            );
        } finally {
            em.close();
        }
    }
}
