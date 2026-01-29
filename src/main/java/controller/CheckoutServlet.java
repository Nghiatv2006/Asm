package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import jakarta.persistence.*;
import model.*;
import utils.JpaUtil;

@WebServlet(urlPatterns = {"/checkout", "/dat-hang"})
public class CheckoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String[] productIdArr = request.getParameterValues("productIds");
        if (productIdArr == null || productIdArr.length == 0) {
            response.sendRedirect("wishlist");
            return;
        }
        
        List<Integer> productIds = new ArrayList<>();
        for (String s : productIdArr) {
            try { 
                productIds.add(Integer.parseInt(s)); 
            } catch (Exception ignore) {}
        }
        
        if (productIds.isEmpty()) {
            response.sendRedirect("wishlist");
            return;
        }
        
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Product> products = em.createQuery(
                "SELECT p FROM Product p WHERE p.id IN :ids", Product.class)
                .setParameter("ids", productIds)
                .getResultList();
            
            BigDecimal total = BigDecimal.ZERO;
            for (Product p : products) {
                total = total.add(p.getPrice());
            }
            
            request.setAttribute("checkoutList", products);
            request.setAttribute("checkoutTotal", total);
            
            request.getRequestDispatcher("/views/checkout.jsp").forward(request, response);
            
        } finally {
            em.close();
        }
    }
    
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
        
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        
        String[] productIdArr = request.getParameterValues("productIds");
        String[] quantityArr = request.getParameterValues("quantities");
        
        if (productIdArr == null || quantityArr == null || productIdArr.length != quantityArr.length) {
            response.sendRedirect("dat-hang");
            return;
        }
        
        List<Integer> productIds = new ArrayList<>();
        List<Integer> quantities = new ArrayList<>();
        
        for (int i = 0; i < productIdArr.length; i++) {
            try {
                int pid = Integer.parseInt(productIdArr[i]);
                int qty = Integer.parseInt(quantityArr[i]);
                if (qty < 1) qty = 1;
                if (qty > 10) qty = 10;
                productIds.add(pid);
                quantities.add(qty);
            } catch (Exception ignore) {}
        }
        
        if (productIds.isEmpty()) {
            response.sendRedirect("wishlist");
            return;
        }
        
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            
            Order order = new Order();
            order.setOrderDate(java.time.LocalDateTime.now());
            order.setStatus("COMPLETED"); // Sửa thành COMPLETED
            order.setUser(user);
            order.setShippingAddress(address);
            order.setRecipientName(fullname);
            order.setRecipientEmail(email);
            order.setRecipientPhone(phone);
            order.setTotalAmount(BigDecimal.ZERO);
            
            em.persist(order);
            
            BigDecimal total = BigDecimal.ZERO;
            
            for (int i = 0; i < productIds.size(); i++) {
                Product product = em.find(Product.class, productIds.get(i));
                if (product == null) continue;
                
                int qty = quantities.get(i);
                
                OrderDetail detail = new OrderDetail();
                detail.setOrder(order);
                detail.setBookTitle(product.getBookTitle());
                detail.setProductImage(product.getImagePath());
                detail.setProductPrice(product.getPrice());
                detail.setQuantity(qty);
                
                em.persist(detail);
                
                BigDecimal lineTotal = product.getPrice().multiply(new BigDecimal(qty));
                total = total.add(lineTotal);
            }
            
            order.setTotalAmount(total);
            em.merge(order);
            
            Query q = em.createQuery("DELETE FROM ProductWishlist w WHERE w.user.id = :uid AND w.product.id IN :ids");
            q.setParameter("uid", user.getId());
            q.setParameter("ids", productIds);
            q.executeUpdate();
            
            tx.commit();
            
            // SỬA LẠI: Ghi HTML đầy đủ
            response.getWriter().write(
                "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                + "<script>Swal.fire({icon:'success',title:'Thanh toán thành công!',text:'Đơn hàng của bạn đã được ghi nhận.', confirmButtonText:'OK', allowOutsideClick:false })"
                + ".then(()=>{window.location='home';});</script>"
                + "</body></html>"
            );
            
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            e.printStackTrace();
            response.getWriter().write(
                "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
                + "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script></head><body>"
                + "<script>Swal.fire({icon:'error',title:'Lỗi đặt hàng',text:'Có lỗi xảy ra: " + e.getMessage() + "',confirmButtonText:'OK'}).then(()=>{window.location='dat-hang';});</script>"
                + "</body></html>"
            );
        } finally {
            em.close();
        }
    }
}
