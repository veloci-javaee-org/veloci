package servlet;

import java.io.IOException;
import java.sql.SQLException;

import dao.OrderDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;

@WebServlet("/order-details")
public class OrderDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = (String) req.getSession().getAttribute("username");

        int orderId;
        try {
            orderId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        try {
            Order order = new OrderDaoImpl().findOrderDetails(orderId, username);
            if (order == null) {
                res.sendRedirect(req.getContextPath() + "/orders");
                return;
            }
            req.setAttribute("order", order);
            req.getRequestDispatcher("/WEB-INF/views/customer/order-details.jsp").forward(req, res);
        } catch (SQLException e) {
            throw new ServletException("Could not load order", e);
        }
    }
}