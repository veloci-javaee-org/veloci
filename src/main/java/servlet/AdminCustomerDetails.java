package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Customer;
import models.Order;
import service.AdminService;

import java.io.IOException;
import java.util.List;

import dao.CustomerDaoImpl;
import dao.OrderDaoImpl;
import exceptions.DBException;
import exceptions.CustomerNotFoundException;


@WebServlet("/admin/customer-details")
public class AdminCustomerDetails extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private final AdminService service = new AdminService(new OrderDaoImpl(), new CustomerDaoImpl());   
  
    public AdminCustomerDetails() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id;
		try {
			id = Integer.parseInt(request.getParameter("id"));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID.");
			return;
		}
		
		try {
			Customer customer = service.getCustomerById(id);
			List<Order> orders = service.getOrdersByCustomerId(id);
			
			request.setAttribute("customer", customer);		
			request.setAttribute("orders", orders);
			
			request.getRequestDispatcher("/WEB-INF/views/admin/admin-customer-details.jsp").forward(request, response);
		}
		catch(DBException e) {
			e.printStackTrace();
			request.getRequestDispatcher("/WEB-INF/views/errors/data-issue.jsp").forward(request, response);
		}
		catch(CustomerNotFoundException e) {
			e.printStackTrace();
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/errors/not-found.jsp").forward(request, response);
		}
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
