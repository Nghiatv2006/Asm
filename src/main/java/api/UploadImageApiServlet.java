package api;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/api/upload-image")
@MultipartConfig
public class UploadImageApiServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images";
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        Part filePart = req.getPart("image");
        if (filePart == null || filePart.getSize() == 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mapper.writeValue(resp.getOutputStream(),
                    new ApiError("File 'image' is required"));
            return;
        }

        try {
            String imagePath = uploadImage(req, filePart);
            mapper.writeValue(resp.getOutputStream(),
                    new UploadResult(imagePath));
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            mapper.writeValue(resp.getOutputStream(),
                    new ApiError("Upload error: " + e.getMessage()));
        }
    }

    // copy ý tưởng từ ProductManagementServlet.uploadImage
    private String uploadImage(HttpServletRequest request, Part filePart) throws IOException {
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String fileName = extractFileName(filePart);
        String filePath = uploadPath + File.separator + fileName;

        filePart.write(filePath);

        // path lưu trong DB, giống project cũ: /images/xxx.jpg
        return "/" + UPLOAD_DIR + "/" + fileName;
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return "unknown";
        for (String token : contentDisp.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return new File(fileName).getName();
            }
        }
        return "unknown";
    }

    public static class UploadResult {
        public String imagePath;

        public UploadResult(String imagePath) {
            this.imagePath = imagePath;
        }
    }

    public static class ApiError {
        public String error;

        public ApiError(String error) {
            this.error = error;
        }
    }
}
