package utils;

import java.io.File;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "";
    private static final String SENDER_PASSWORD = ""; // App Password (bỏ dấu cách)

    // Method gửi email đơn giản (dùng cho OTP)
    public static void sendEmail(String recipientEmail, String subject, String htmlBody) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    // Method gửi email sản phẩm (giữ nguyên)
    public static boolean sendProductEmail(String recipientEmail, String productName, 
                                           String author, String publisher, String category,
                                           String price, String description, String imagePath) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Bạn bè vừa chia sẻ cuốn sách: " + productName);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();
            String htmlContent = String.format(
                "<html><body style='font-family: Arial, sans-serif;'>" +
                "<h2 style='color: #667eea;'>📚 Bạn của bạn vừa chia sẻ cuốn sách này!</h2>" +
                "<div style='border: 1px solid #ddd; padding: 20px; border-radius: 10px; max-width: 600px;'>" +
                "<img src='cid:productImage' style='width: 100%%; max-width: 300px; border-radius: 8px; display: block; margin: 0 auto;'>" +
                "<h3 style='color: #333; margin-top: 20px;'>%s</h3>" +
                "<p><strong>Tác giả:</strong> %s</p>" +
                "<p><strong>Nhà xuất bản:</strong> %s</p>" +
                "<p><strong>Thể loại:</strong> %s</p>" +
                "<p><strong>Giá:</strong> <span style='color: #28a745; font-size: 20px; font-weight: bold;'>%s</span></p>" +
                "<p><strong>Mô tả:</strong> %s</p>" +
                "</div>" +
                "<p style='color: #888; margin-top: 20px; font-size: 12px;'>Email này được gửi từ Bookstore.</p>" +
                "</body></html>",
                productName, author, publisher, category, price, description
            );
            messageBodyPart.setContent(htmlContent, "text/html; charset=UTF-8");
            multipart.addBodyPart(messageBodyPart);

            if (imagePath != null && !imagePath.isEmpty()) {
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    MimeBodyPart imageBodyPart = new MimeBodyPart();
                    imageBodyPart.attachFile(imageFile);
                    imageBodyPart.setContentID("<productImage>");
                    imageBodyPart.setDisposition(MimeBodyPart.INLINE);
                    multipart.addBodyPart(imageBodyPart);
                }
            }

            message.setContent(multipart);
            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
