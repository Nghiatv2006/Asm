package api;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityManager;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import utils.JpaUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/categories")
public class CategoryApiServlet extends HttpServlet {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json;charset=UTF-8");

        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Category> cats = em.createQuery(
                    "SELECT c FROM Category c", Category.class
            ).getResultList();
            mapper.writeValue(resp.getOutputStream(), cats);
        } finally {
            em.close();
        }
    }
}
