package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.*;
import model.User;
import utils.JpaUtil;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public HomeServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null; // ĐÚNG KEY

        String searchQuery = request.getParameter("search");
        String searchType = request.getParameter("searchType"); // "name" hoặc "author"
        String categoryIdParam = request.getParameter("categoryId");

        EntityManager em = JpaUtil.getEntityManager();

        try {
            String jpqlCategories = "SELECT c FROM Category c ORDER BY c.categoryName";
            TypedQuery<Category> categoryQuery = em.createQuery(jpqlCategories, Category.class);
            List<Category> categories = categoryQuery.getResultList();

            StringBuilder jpql = new StringBuilder("SELECT p FROM Product p WHERE 1=1");
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                if ("author".equals(searchType)) {
                    jpql.append(" AND LOWER(p.author) LIKE LOWER(:search)");
                } else {
                    jpql.append(" AND LOWER(p.bookTitle) LIKE LOWER(:search)");
                }
            }
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                jpql.append(" AND p.category.id = :categoryId");
            }
            jpql.append(" ORDER BY p.createdDate DESC");
            TypedQuery<Product> productQuery = em.createQuery(jpql.toString(), Product.class);
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                productQuery.setParameter("search", "%" + searchQuery + "%");
            }
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                productQuery.setParameter("categoryId", Integer.parseInt(categoryIdParam));
            }
            List<Product> products = productQuery.getResultList();

            Map<Integer, Long> categoryCountMap = new HashMap<>();
            for (Category category : categories) {
                String jpqlCount = "SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId";
                Long count = em.createQuery(jpqlCount, Long.class)
                        .setParameter("categoryId", category.getId())
                        .getSingleResult();
                categoryCountMap.put(category.getId(), count);
            }

            String jpqlTotal = "SELECT COUNT(p) FROM Product p";
            Long totalCount = em.createQuery(jpqlTotal, Long.class).getSingleResult();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("categoryCountMap", categoryCountMap);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("searchType", searchType != null ? searchType : "name");
            request.setAttribute("selectedCategoryId", categoryIdParam);
            request.setAttribute("loggedInUser", loggedInUser); // ĐÚNG TÊN

            request.getRequestDispatcher("/views/home.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
