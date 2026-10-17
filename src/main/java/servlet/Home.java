package servlet;

import java.io.IOException;
import java.util.List;

import dao.CategoryDAO;
import dao.CategoryDAOImpl;
import dao.ProductDAO;
import dao.ProductDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Category;
import models.Product;

@WebServlet("/home")
public class Home extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final ProductDAO productDAO = new ProductDAOImpl();
	private final CategoryDAO categoryDAO = new CategoryDAOImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Product> products = productDAO.getAllProduct();
		List<Category> categories = categoryDAO.findAll();
		request.setAttribute("featuredProducts", products.size() > 4 ? products.subList(0, 4) : products);
		request.setAttribute("storeCategories", categories);
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}
}