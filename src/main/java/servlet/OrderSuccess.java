package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Shows the order success page. It is reachable only through this servlet,
 * and only when an order was just placed (lastOrderId exists in the session).
 */
@WebServlet("/order-success")
public class OrderSuccess extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // No order was just placed: send them away
        if (session == null || session.getAttribute("lastOrderId") == null) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/customer/order-success.jsp").forward(req, res);
    }
}