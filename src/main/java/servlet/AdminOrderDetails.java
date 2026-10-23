package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import service.AdminService;

import java.io.IOException;

import dao.OrderDAOImpl;
import enums.OrderStatus;
import exceptions.DBException;
import exceptions.OrderNotFoundException;


@WebServlet("/admin/order-details")
public class AdminOrderDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final AdminService service = new AdminService(new OrderDAOImpl(), null);   

    public AdminOrderDetails() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int id = Integer.parseInt(request.getParameter("id"));
		
		try {
			Order order = service.getOrderById(id);
			request.setAttribute("order", order);
			request.getRequestDispatcher("/views/admin-order-details.jsp").forward(request, response);
		}
		catch(DBException e) {
			e.printStackTrace();
			request.getRequestDispatcher("/data-issue.jsp").forward(request, response);
		}
		catch(OrderNotFoundException e) {
			e.printStackTrace();
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/not-found.jsp").forward(request, response);
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		OrderStatus status = OrderStatus.valueOf(request.getParameter("status").toUpperCase());
		try {
			service.updateOrderStatus(id, status);
			request.getRequestDispatcher("/admin/orders").forward(request, response);
		}
		catch(OrderNotFoundException e) {
			e.printStackTrace();
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/not-found.jsp").forward(request, response);
		}
		
	}

}
