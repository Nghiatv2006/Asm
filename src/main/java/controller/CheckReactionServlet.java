package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.ProductInteraction;
import utils.JpaUtil;

@WebServlet("/check-reaction")
public class CheckReactionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CheckReactionServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		// Kiểm tra đã login chưa
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loggedInUser") == null) {
			response.getWriter().write("{\"hasReaction\": false}");
			return;
		}
		
		int userId = (int) session.getAttribute("userId");
		String productIdParam = request.getParameter("productId");
		
		if (productIdParam == null) {
			response.getWriter().write("{\"hasReaction\": false}");
			return;
		}
		
		int productId = Integer.parseInt(productIdParam);
		
		EntityManager em = JpaUtil.getEntityManager();
		
		try {
			String jpql = "SELECT pi FROM ProductInteraction pi WHERE pi.userId = :userId AND pi.productId = :productId";
			TypedQuery<ProductInteraction> query = em.createQuery(jpql, ProductInteraction.class);
			query.setParameter("userId", userId);
			query.setParameter("productId", productId);
			
			ProductInteraction interaction = query.getSingleResult();
			
			// Có reaction
			String jsonResponse = String.format(
				"{\"hasReaction\": true, \"actionType\": \"%s\"}", 
				interaction.getActionType()
			);
			response.getWriter().write(jsonResponse);
			
		} catch (NoResultException e) {
			// Chưa có reaction
			response.getWriter().write("{\"hasReaction\": false}");
		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"hasReaction\": false}");
		} finally {
			em.close();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
