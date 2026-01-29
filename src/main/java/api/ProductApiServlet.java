package api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;
import utils.JpaUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/api/products/*")
public class ProductApiServlet extends HttpServlet {

    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    // GET /api/products        -> list tất cả
    // GET /api/products/{id}   -> chi tiết 1 sản phẩm
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        String pathInfo = req.getPathInfo(); // /{id} hoặc null
        EntityManager em = JpaUtil.getEntityManager();

        try {
            if (pathInfo == null || "/".equals(pathInfo)) {
                // GET /api/products -> list
                List<Product> products = em.createQuery(
                        "SELECT p FROM Product p", Product.class
                ).getResultList();

                List<ProductResponse> result = products.stream()
                        .map(this::toResponse)
                        .collect(Collectors.toList());

                objectMapper.writeValue(resp.getOutputStream(), result);
            } else {
                // GET /api/products/{id}
                String[] parts = pathInfo.split("/");
                if (parts.length < 2) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    objectMapper.writeValue(resp.getOutputStream(),
                            new ApiError("Invalid URL, expected /api/products/{id}"));
                    return;
                }

                int id;
                try {
                    id = Integer.parseInt(parts[1]);
                } catch (NumberFormatException e) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    objectMapper.writeValue(resp.getOutputStream(),
                            new ApiError("Invalid product id"));
                    return;
                }

                Product product = em.find(Product.class, id);
                if (product == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    objectMapper.writeValue(resp.getOutputStream(),
                            new ApiError("Product not found"));
                    return;
                }

                objectMapper.writeValue(resp.getOutputStream(), toResponse(product));
            }
        } finally {
            em.close();
        }
    }

    // POST /api/products  -> tạo mới
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        ProductRequest body = readRequestBody(req);
        if (body == null || body.bookTitle == null || body.bookTitle.isBlank()
                || body.price == null || body.categoryId == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Missing required fields: bookTitle, price, categoryId"));
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Category category = em.find(Category.class, body.categoryId);
            if (category == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                objectMapper.writeValue(resp.getOutputStream(),
                        new ApiError("Category not found"));
                tx.rollback();
                return;
            }

            Product product = new Product();
            product.setBookTitle(body.bookTitle);
            product.setAuthor(body.author);
            product.setPublisher(body.publisher);
            product.setPrice(body.price);
            product.setStockQuantity(body.stockQuantity != null ? body.stockQuantity : 0);
            product.setDescription(body.description);
            product.setImagePath(body.imagePath);
            product.setCategory(category);

            em.persist(product);
            tx.commit();

            resp.setStatus(HttpServletResponse.SC_CREATED);
            objectMapper.writeValue(resp.getOutputStream(), toResponse(product));

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Server error: " + e.getMessage()));
        } finally {
            em.close();
        }
    }

    // PUT /api/products/{id} -> cập nhật
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Missing product id in URL"));
            return;
        }

        String[] parts = pathInfo.split("/");
        if (parts.length < 2) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Invalid URL, expected /api/products/{id}"));
            return;
        }

        int id;
        try {
            id = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Invalid product id"));
            return;
        }

        ProductRequest body = readRequestBody(req);
        if (body == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Invalid JSON body"));
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Product product = em.find(Product.class, id);
            if (product == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                objectMapper.writeValue(resp.getOutputStream(),
                        new ApiError("Product not found"));
                tx.rollback();
                return;
            }

            if (body.bookTitle != null) product.setBookTitle(body.bookTitle);
            if (body.author != null) product.setAuthor(body.author);
            if (body.publisher != null) product.setPublisher(body.publisher);
            if (body.price != null) product.setPrice(body.price);
            if (body.stockQuantity != null) product.setStockQuantity(body.stockQuantity);
            if (body.description != null) product.setDescription(body.description);
            if (body.imagePath != null) product.setImagePath(body.imagePath);

            if (body.categoryId != null) {
                Category category = em.find(Category.class, body.categoryId);
                if (category == null) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    objectMapper.writeValue(resp.getOutputStream(),
                            new ApiError("Category not found"));
                    tx.rollback();
                    return;
                }
                product.setCategory(category);
            }

            em.merge(product);
            tx.commit();

            objectMapper.writeValue(resp.getOutputStream(), toResponse(product));

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Server error: " + e.getMessage()));
        } finally {
            em.close();
        }
    }

    // DELETE /api/products/{id} -> xóa
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Missing product id in URL"));
            return;
        }

        String[] parts = pathInfo.split("/");
        if (parts.length < 2) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Invalid URL, expected /api/products/{id}"));
            return;
        }

        int id;
        try {
            id = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Invalid product id"));
            return;
        }

        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            Product product = em.find(Product.class, id);
            if (product == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                objectMapper.writeValue(resp.getOutputStream(),
                        new ApiError("Product not found"));
                tx.rollback();
                return;
            }

            em.remove(product);
            tx.commit();

            objectMapper.writeValue(resp.getOutputStream(),
                    new SimpleMessage("Product deleted"));

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(resp.getOutputStream(),
                    new ApiError("Server error: " + e.getMessage()));
        } finally {
            em.close();
        }
    }

    // map Product -> DTO có categoryName
    private ProductResponse toResponse(Product p) {
        ProductResponse r = new ProductResponse();
        r.id = p.getId();
        r.bookTitle = p.getBookTitle();
        r.author = p.getAuthor();
        r.publisher = p.getPublisher();
        r.price = p.getPrice();
        r.stockQuantity = p.getStockQuantity();
        r.description = p.getDescription();
        r.imagePath = p.getImagePath();
        r.viewCount = p.getViewCount();
        r.likeCount = p.getLikeCount();
        r.dislikeCount = p.getDislikeCount();
        r.createdDate = p.getCreatedDate();
        if (p.getCategory() != null) {
            r.categoryName = p.getCategory().getCategoryName();
            r.categoryId = p.getCategory().getId();
        }
        return r;
    }

    // Đọc JSON body thành ProductRequest
    private ProductRequest readRequestBody(HttpServletRequest req) {
        try (BufferedReader reader = req.getReader()) {
            return objectMapper.readValue(reader, ProductRequest.class);
        } catch (IOException e) {
            return null;
        }
    }

    // DTO cho request JSON
    public static class ProductRequest {
        public String bookTitle;
        public String author;
        public String publisher;
        public BigDecimal price;
        public Integer stockQuantity;
        public String description;
        public String imagePath;
        public Integer categoryId;
    }

    // DTO response có categoryName + categoryId
    public static class ProductResponse {
        public Integer id;
        public String bookTitle;
        public String author;
        public String publisher;
        public BigDecimal price;
        public Integer stockQuantity;
        public String description;
        public String imagePath;
        public Integer viewCount;
        public Integer likeCount;
        public Integer dislikeCount;
        public java.time.LocalDateTime createdDate;
        public String categoryName;
        public Integer categoryId;
    }

    // DTO đơn giản cho lỗi / message
    public static class ApiError {
        public String error;

        public ApiError(String error) {
            this.error = error;
        }
    }

    public static class SimpleMessage {
        public String message;

        public SimpleMessage(String message) {
            this.message = message;
        }
    }
}
