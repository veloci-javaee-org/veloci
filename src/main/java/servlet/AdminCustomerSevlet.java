package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Customer;
import service.AdminService;

import java.io.IOException;
import java.util.List;

import dao.CustomerDaoImpl;
import exceptions.DBException;




@WebServlet("/admin/customers")
public class AdminCustomerSevlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final AdminService service = new AdminService(null, new CustomerDaoImpl());

  
    public AdminCustomerSevlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<Customer> customers = service.getCustomers();
			request.setAttribute("customers", customers);
			request.getRequestDispatcher("/WEB-INF/views/admin/admin-customers.jsp").forward(request, response);
		}
		catch(DBException e) {
			request.setAttribute("message", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/errors/data-issue.jsp").forward(request, response);
		}
		
		
	}


}
