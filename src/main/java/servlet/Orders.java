package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.OrderDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.OrderSummary;

@WebServlet("/orders")
public class Orders extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // The filter already guarantees a logged-in customer for /orders
        String username = (String) req.getSession().getAttribute("username");

        try {
            List<OrderSummary> orders = new OrderDaoImpl().findOrdersByUsername(username);
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/views/customer/orders.jsp").forward(req, res);
        } catch (SQLException e) {
            throw new ServletException("Could not load orders", e);
        }
    }
}