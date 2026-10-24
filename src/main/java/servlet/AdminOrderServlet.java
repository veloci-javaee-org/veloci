package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import service.AdminService;

import java.io.IOException;
import java.util.List;

import dao.OrderDaoImpl;
import exceptions.DBException;


@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final AdminService service = new AdminService(new OrderDaoImpl(), null);
       
  
    public AdminOrderServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<Order> orders = service.getOrders();
			request.setAttribute("orders", orders);
			request.getRequestDispatcher("/views/admin/admin-orders.jsp").forward(request, response);
		}
		catch(DBException e) {
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/data-issue.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
