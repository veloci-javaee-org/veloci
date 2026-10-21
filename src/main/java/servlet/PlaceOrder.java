package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import dao.OrderDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PlaceOrder")
public class PlaceOrder extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // Opening /PlaceOrder directly in the browser: nothing to do here
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("username");
        List<Map<String, Object>> items =
                (List<Map<String, Object>>) session.getAttribute("cartItems");

        // 1. Empty cart: nothing to order
        if (items == null || items.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 2. Read and check the form values
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        if (phone == null || phone.isBlank() || address == null || address.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // 3. Create the order
        try {
            int orderId = new OrderDaoImpl().createOrder(username, phone.trim(), address.trim(), items);

         // Keep a copy of the order details for the success page
            double subtotal = 0;
            for (Map<String, Object> item : items) {
                subtotal += (Double) item.get("lineTotal");
            }
            double shipping = 50.0;

            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderItems", items);
            session.setAttribute("lastOrderSubtotal", subtotal);
            session.setAttribute("lastOrderShipping", shipping);
            session.setAttribute("lastOrderTotal", subtotal + shipping);
            session.setAttribute("lastOrderPhone", phone.trim());
            session.setAttribute("lastOrderAddress", address.trim());
            
            // 4. Only after success: clear the cart
            session.removeAttribute("cartItems");
            res.sendRedirect(req.getContextPath() + "/order-success");

        } catch (SQLException e) {
            e.printStackTrace();   // shows the real reason in the Eclipse console
            res.sendRedirect(req.getContextPath() + "/checkout?error=order");
        }
    }
}