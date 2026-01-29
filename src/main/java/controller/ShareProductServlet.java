package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.persistence.EntityManager;
import model.Product;
import utils.JpaUtil;
import utils.EmailUtil;

@WebServlet("/share-product")
public class ShareProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Bạn cần đăng nhập!\"}");
            return;
        }

        String productIdParam = request.getParameter("productId");
        String recipientEmail = request.getParameter("recipientEmail");

        if (productIdParam == null || recipientEmail == null || recipientEmail.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin!\"}");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        EntityManager em = JpaUtil.getEntityManager();

        try {
            Product product = em.find(Product.class, productId);
            if (product == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm không tồn tại!\"}");
                return;
            }

            // Lấy đường dẫn ảnh thật từ server
            String imagePath = getServletContext().getRealPath(product.getImagePath());
            String price = String.format("%,d đ", product.getPrice().intValue());
            String description = (product.getDescription() != null) ? product.getDescription() : "Chưa có mô tả.";
            String publisher = (product.getPublisher() != null) ? product.getPublisher() : "Đang cập nhật";

            // Gửi email
            boolean sent = EmailUtil.sendProductEmail(
                recipientEmail,
                product.getBookTitle(),
                product.getAuthor(),
                publisher,
                product.getCategory().getCategoryName(),
                price,
                description,
                imagePath
            );

            if (sent) {
                response.getWriter().write("{\"success\": true, \"message\": \"Đã gửi email thành công!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Gửi email thất bại!\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        } finally {
            em.close();
        }
    }
}
