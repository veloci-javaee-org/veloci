package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import models.Category;
import service.CategoryService;
import service.CategoryServiceImpl;
import exceptions.ValidationException;

@WebServlet("/admin/categories")
public class CategoryServlet extends HttpServlet {

	private CategoryService categoryService;

	@Override
	public void init() throws ServletException {
		categoryService = new CategoryServiceImpl();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {

		case "new":
			// No category attribute → form knows it's "add mode"
			request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
			break;

		case "edit": {
			int id = parseId(request, response);
			if (id == -1)
				return;

			Category category = categoryService.getById(id);
			if (category == null) {
				response.sendRedirect(request.getContextPath() + "/admin/categories");
				return;
			}
			request.setAttribute("category", category);
			request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
			break;
		}

		case "list":
		default:
			loadListPage(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		if ("delete".equals(request.getParameter("action"))) {
			int id = parseId(request, response);
			if (id == -1)
				return;

			int productCount = categoryService.countProducts(id);
			categoryService.delete(id);
			String msg = (productCount > 0) ? "Category deleted. " + productCount + " product(s) are now uncategorized."
					: "Category deleted successfully.";
			redirect(request, response, msg);
			return;
		}

		String idParam = request.getParameter("id");
		boolean isCreate = (idParam == null || idParam.isBlank() || "0".equals(idParam.trim()));

		Category category = new Category();
		if (!isCreate) {
			try {
				category.setId(Integer.parseInt(idParam.trim()));
			} catch (NumberFormatException e) {
				request.setAttribute("error", "Invalid category ID.");
				request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
				return;
			}
		}
		category.setName(request.getParameter("name"));
		category.setDescription(request.getParameter("description"));

		try {
			if (isCreate) {
				categoryService.create(category);
				redirect(request, response, "Category \"" + category.getName() + "\" added successfully.");
			} else {
				categoryService.update(category);
				redirect(request, response, "Category \"" + category.getName() + "\" updated successfully.");
			}

		} catch (ValidationException e) {
			// Return to form with input preserved + error message
			request.setAttribute("category", category);
			request.setAttribute("error", e.getMessage());
			request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
		}
	}

	// ── Helpers ──────────────────────────────────────────────────────────
	private void loadListPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Category> categories = categoryService.getAll();

		// Build productCounts map: categoryId → number of products
		Map<Integer, Integer> productCounts = new HashMap<>();
		for (Category cat : categories) {
			productCounts.put(cat.getId(), categoryService.countProducts(cat.getId()));
		}

		request.setAttribute("categories", categories);
		request.setAttribute("productCounts", productCounts);
		request.getRequestDispatcher("/views/categories.jsp").forward(request, response);
	}

	/**
	 * Parses the "id" param. Returns -1 and redirects to list if invalid.
	 */
	private int parseId(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String idParam = request.getParameter("id");
		if (idParam == null || idParam.isBlank()) {
			response.sendRedirect(request.getContextPath() + "/admin/categories");
			return -1;
		}
		try {
			return Integer.parseInt(idParam.trim());
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/categories");
			return -1;
		}
	}

	private void redirect(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
		response.sendRedirect(
				request.getContextPath() + "/admin/categories?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
	}
}