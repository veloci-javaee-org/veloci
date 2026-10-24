package servlet;

import jakarta.servlet.ServletException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class CheckOut
 */
@WebServlet("/checkout")
public class CheckOut extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckOut() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession();

        // 1. Must be logged in
        Object username = session.getAttribute("username");
        if (username == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Cart must not be empty
        List<Map<String, Object>> items = (List<Map<String, Object>>) session.getAttribute("cartItems");
        if (items == null || items.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 3. Calculate
        double subtotal = 0;
        for (Map<String, Object> item : items) {
            subtotal += (Double) item.get("lineTotal");
        }
        double shipping = 50.0;                 // your rule: flat, free over X, etc.
        double totalPrice = subtotal + shipping;

        req.setAttribute("subtotal", subtotal);
        req.setAttribute("shipping", shipping);
        req.setAttribute("totalPrice", totalPrice);
        req.getRequestDispatcher("/WEB-INF/views/customer/checkout.jsp").forward(req, res);
    }
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
