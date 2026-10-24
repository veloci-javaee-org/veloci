package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product;
import models.Category;

import java.io.IOException;
import java.util.List;
import java.util.Comparator;

import dao.CategoryDAO;
import dao.CategoryDAOImpl;
import dao.ProductDAO;
import dao.ProductDAOImpl;

public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductDAO productDAO;
	private CategoryDAO categoryDAO;

	@Override
	public void init() throws ServletException {
		productDAO = new ProductDAOImpl();
		categoryDAO = new CategoryDAOImpl();
	}

	public ProductServlet() {

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getServletPath();

		if ("/product-details".equals(path)) {
			handleProductDetails(request, response);
		} else if ("/search".equals(path)) {
			handleSearch(request, response);
		} else {
			handleBrowseAll(request, response);
		}
	}

	private void handleBrowseAll(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Product> products = productDAO.getAllProduct();
		String keyword = request.getParameter("keyword");
		String category = request.getParameter("category");
		String sort = request.getParameter("sort");
		List<Category> categories = categoryDAO.findAll();

		if (keyword != null && !keyword.isBlank()) {
			products.removeIf(p -> p.getName() == null || !p.getName().toLowerCase().contains(keyword.toLowerCase()));
		}
		if (category != null && !category.isBlank()) {
			products.removeIf(p -> p.getCategory() == null || !category.equalsIgnoreCase(p.getCategory().getName()));
		}
		if ("price_asc".equals(sort))
			products.sort(Comparator.comparingDouble(Product::getPrice));
		else if ("price_desc".equals(sort))
			products.sort(Comparator.comparingDouble(Product::getPrice).reversed());
		else if ("name".equals(sort))
			products.sort(Comparator.comparing(Product::getName, String.CASE_INSENSITIVE_ORDER));

		request.setAttribute("products", products);
		request.setAttribute("categories", categories);
		request.setAttribute("searchKeyword", keyword);
		request.setAttribute("selectedCategory", category);
		request.setAttribute("sort", sort);
		request.getRequestDispatcher("/WEB-INF/views/customer/products.jsp").forward(request, response);
	}

	private void handleSearch(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String keyword = request.getParameter("keyword");
		request.setAttribute("searchKeyword", keyword);
		handleBrowseAll(request, response);
	}

	private void handleProductDetails(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String idParam = request.getParameter("id");
		if (idParam == null || idParam.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		try {
			int id = Integer.parseInt(idParam);
			if (id <= 0) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST);
				return;
			}
			Product product = productDAO.getProductById(id);

			if (product != null) {
				request.setAttribute("product", product);
				request.getRequestDispatcher("/WEB-INF/views/customer/product-details.jsp").forward(request, response);
			} else {
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
	}

}
