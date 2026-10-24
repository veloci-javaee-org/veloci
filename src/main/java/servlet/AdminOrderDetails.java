package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import service.AdminService;

import java.io.IOException;

import dao.OrderDaoImpl;
import enums.OrderStatus;
import exceptions.DBException;
import exceptions.OrderNotFoundException;


@WebServlet("/admin/order-details")
public class AdminOrderDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final AdminService service = new AdminService(new OrderDaoImpl(), null);   

    public AdminOrderDetails() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id;
		try {
			id = Integer.parseInt(request.getParameter("id"));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID.");
			return;
		}
		
		try {
			Order order = service.getOrderById(id);
			request.setAttribute("order", order);
			request.getRequestDispatcher("/WEB-INF/views/admin/admin-order-details.jsp").forward(request, response);
		}
		catch(DBException e) {
			e.printStackTrace();
			request.getRequestDispatcher("/WEB-INF/views/errors/data-issue.jsp").forward(request, response);
		}
		catch(OrderNotFoundException e) {
			e.printStackTrace();
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/errors/not-found.jsp").forward(request, response);
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id;
		try {
			id = Integer.parseInt(request.getParameter("id"));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID.");
			return;
		}

		OrderStatus status;
		try {
			status = OrderStatus.valueOf(request.getParameter("status").toUpperCase());
		} catch (IllegalArgumentException | NullPointerException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order status.");
			return;
		}
		try {
			service.updateOrderStatus(id, status);
			request.getRequestDispatcher("/admin/orders").forward(request, response);
		}
		catch(OrderNotFoundException e) {
			e.printStackTrace();
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/errors/not-found.jsp").forward(request, response);
		}
		
	}

}
