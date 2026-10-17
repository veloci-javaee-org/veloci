package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.CategoryDAO;
import dao.CategoryDAOImpl;
import dao.ProductDAO;
import dao.ProductDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import models.Category;
import models.Product;
import models.ProductImage;
import exceptions.ValidationException;
import util.ImageHelper;

/**
 * Admin Product Management — /admin/products
 *
 * Routing (action param):
 * GET  /admin/products                      → list (+ optional ?keyword=)
 * GET  /admin/products?action=new           → add form
 * GET  /admin/products?action=edit&id=X     → edit form
 * GET  /admin/products?action=stock&id=X    → stock update form
 * POST /admin/products                      → create / update (id==0 → create)
 * POST /admin/products?action=delete        → delete product
 * POST /admin/products?action=updateStock   → save new stock value
 * POST /admin/products?action=addImage      → upload one image to existing product
 * POST /admin/products?action=deleteImage   → remove one image by imageId
 */
@WebServlet("/admin/products")
@MultipartConfig(fileSizeThreshold = 2 * 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class AdminProductServlet extends HttpServlet {

	private ProductDAO productDAO;
	private CategoryDAO categoryDAO;

	@Override
	public void init() throws ServletException {
		productDAO = new ProductDAOImpl();
		categoryDAO = new CategoryDAOImpl();
	}

	// ── GET ──────────────────────────────────────────────────────────────
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		String action = req.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {

		case "new":
			req.setAttribute("categories", categoryDAO.findAll());
			req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, res);
			break;

		case "edit": {
			Product p = productDAO.getProductById(parseInt(req, "id"));
			if (p == null) {
				res.sendRedirect(base(req));
				return;
			}
			req.setAttribute("product", p);
			req.setAttribute("categories", categoryDAO.findAll());
			req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, res);
			break;
		}

		case "stock": {
			Product p = productDAO.getProductById(parseInt(req, "id"));
			if (p == null) {
				res.sendRedirect(base(req));
				return;
			}
			req.setAttribute("product", p);
			req.getRequestDispatcher("/views/admin/product-stock.jsp").forward(req, res);
			break;
		}

		case "delete":
			res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
			break;

		default: // list
			String keyword = req.getParameter("keyword");
			List<Product> products = (keyword != null && !keyword.isBlank()) ? productDAO.searchProductsByName(keyword)
					: productDAO.getAllProduct();
			req.setAttribute("products", products);
			req.setAttribute("keyword", keyword);
			req.getRequestDispatcher("/views/admin/products.jsp").forward(req, res);
		}
	}

	// ── POST ─────────────────────────────────────────────────────────────

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		String action = req.getParameter("action");
		if (action == null)
			action = "save";

		switch (action) {
		case "delete":
			handleDelete(req, res);
			break;
		case "addImage":
			handleAddImage(req, res);
			break;
		case "deleteImage":
			handleDeleteImage(req, res);
			break;
		case "updateStock":
			handleUpdateStock(req, res);
			break;
		default:
			handleSave(req, res);
		}
	}

	// ── Handlers ─────────────────────────────────────────────────────────

	private void handleSave(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		String idParam = req.getParameter("id");
		boolean isCreate = idParam == null || idParam.isBlank() || "0".equals(idParam.trim());
		Product product;
		try {
			product = buildProductFromParams(req, isCreate ? 0 : Integer.parseInt(idParam.trim()));
		} catch (NumberFormatException e) {
			product = new Product();
			product.setName(req.getParameter("name"));
			product.setDescription(req.getParameter("description"));
			showProductForm(req, res, product, "Enter valid numbers for the product ID, price, stock, and category.");
			return;
		}

		try {
			validate(product);

			if (isCreate) {
				// 1. insert product row
				int newId;
				try {
					newId = productDAO.insertProduct(product);
				} catch (SQLException e) {
					throw new ServletException("Could not save product.", e);
				}
				product.setId(newId);
				saveProductImages(req, newId, product.getName());
				res.sendRedirect(base(req) + "?msg=Product+saved+successfully.");
			} else {
				boolean updated;
				try {
					updated = productDAO.updateProduct(product);
				} catch (SQLException e) {
					throw new ServletException("Could not update product.", e);
				}
				if (!updated) {
					res.sendRedirect(base(req) + "?error=Product+not+found.");
					return;
				}
				saveProductImages(req, product.getId(), product.getName());
				res.sendRedirect(base(req) + "?action=edit&id=" + product.getId() + "&msg=Product+saved+successfully.");
			}

		} catch (ValidationException e) {
			showProductForm(req, res, product, e.getMessage());
		} catch (IllegalArgumentException e) {
			showProductForm(req, res, product, e.getMessage());
		} catch (IOException e) {
			getServletContext().log("Product image upload failed.", e);
			showProductForm(req, res, product,
					"Unable to store the selected image. Check that it is a supported image under 5 MB and try again.");
		}
	}

	private void showProductForm(HttpServletRequest req, HttpServletResponse res, Product product, String error)
			throws ServletException, IOException {
		if (product.getId() > 0) {
			Product savedProduct = productDAO.getProductById(product.getId());
			if (savedProduct != null) {
				product.setImages(savedProduct.getImages());
			}
		}
		req.setAttribute("product", product);
		req.setAttribute("error", error);
		req.setAttribute("categories", categoryDAO.findAll());
		req.getRequestDispatcher("/views/admin/product-form.jsp").forward(req, res);
	}

	private void saveProductImages(HttpServletRequest req, int productId, String productName)
			throws IOException, ServletException {
		String uploadDirectory = req.getServletContext().getRealPath("/images/products");
		for (Part part : req.getParts()) {
			if (!"images".equals(part.getName()) || part.getSize() == 0) {
				continue;
			}

			String path = ImageHelper.save(part, uploadDirectory, productName);
			if (path == null) {
				continue;
			}
			try {
				productDAO.insertImage(productId, path);
			} catch (SQLException e) {
				try {
					ImageHelper.delete(path, req.getServletContext().getRealPath("/"));
				} catch (IOException cleanupError) {
					e.addSuppressed(cleanupError);
				}
				throw new ServletException("The image could not be linked to the product.", e);
			}
		}
	}

	private void handleUpdateStock(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		int id = parseInt(req, "id");
		String stockParam = req.getParameter("stock");
		try {
			if (stockParam == null)
				throw new NumberFormatException();
			int newStock = Integer.parseInt(stockParam.trim());
			if (newStock < 0)
				throw new NumberFormatException();
			try {
				if (!productDAO.updateStock(id, newStock)) {
					res.sendRedirect(base(req) + "?error=Product+not+found.");
					return;
				}
			} catch (SQLException e) {
				throw new ServletException("Could not update product stock.", e);
			}
			res.sendRedirect(base(req) + "?msg=Stock+updated+successfully.");
		} catch (NumberFormatException e) {
			Product p = productDAO.getProductById(id);
			req.setAttribute("product", p);
			req.setAttribute("error", "Stock must be a non-negative whole number.");
			req.getRequestDispatcher("/views/admin/product-stock.jsp").forward(req, res);
		}
	}

	private void handleDelete(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		int id = parseInt(req, "id");
		if (id <= 0) {
			res.sendRedirect(base(req) + "?error=Invalid+product+ID.");
			return;
		}
		try {
			List<ProductImage> images = productDAO.getImagesForProduct(id);
			if (!productDAO.deleteProduct(id)) {
				res.sendRedirect(base(req) + "?error=Product+not+found.");
				return;
			}
			for (ProductImage image : images) {
				ImageHelper.delete(image.getImagePath(), req.getServletContext().getRealPath("/"));
			}
		} catch (SQLException e) {
			throw new ServletException("Could not delete product.", e);
		}
		res.sendRedirect(base(req) + "?msg=Product+deleted+successfully.");
	}

	private void handleAddImage(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		int productId = parseInt(req, "productId");
		try {
			Part part = req.getPart("image");
			String path = ImageHelper.save(part, req.getServletContext().getRealPath("/images/products"),
					getProductName(productId));
			if (path != null) {
				try {
					productDAO.insertImage(productId, path);
				} catch (SQLException e) {
					try {
						ImageHelper.delete(path, req.getServletContext().getRealPath("/"));
					} catch (IOException cleanupError) {
						e.addSuppressed(cleanupError);
					}
					throw new ServletException("The image could not be linked to the product.", e);
				}
			}
			res.sendRedirect(base(req) + "?action=edit&id=" + productId + "&msg=Image+added.");
		} catch (IllegalArgumentException | IOException e) {
			res.sendRedirect(base(req) + "?action=edit&id=" + productId + "&error="
					+ java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
		}
	}

	private void handleDeleteImage(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		int imageId = parseInt(req, "imageId");
		int productId = parseInt(req, "productId");
		List<ProductImage> images = productDAO.getImagesForProduct(productId);
		String path = null;
		for (ProductImage image : images) {
			if (image.getId() == imageId) {
				path = image.getImagePath();
				break;
			}
		}
		if (path == null) {
			res.sendRedirect(base(req) + "?action=edit&id=" + productId + "&error=Image+not+found.");
			return;
		}
		try {
			if (!productDAO.deleteImage(imageId)) {
				res.sendRedirect(base(req) + "?action=edit&id=" + productId + "&error=Image+not+found.");
				return;
			}
		} catch (SQLException e) {
			throw new jakarta.servlet.ServletException("Could not delete product image.", e);
		}
		ImageHelper.delete(path, req.getServletContext().getRealPath("/"));
		res.sendRedirect(base(req) + "?action=edit&id=" + productId);
	}

	// ── Helpers ──────────────────────────────────────────────────────────

	private Product buildProductFromParams(HttpServletRequest req, int id) {
		Product p = new Product();
		p.setId(id);
		p.setName(req.getParameter("name"));
		p.setDescription(req.getParameter("description"));
		String price = req.getParameter("price");
		String stock = req.getParameter("stock");
		p.setPrice(price != null && !price.isBlank() ? Double.parseDouble(price) : 0);
		p.setStock(stock != null && !stock.isBlank() ? Integer.parseInt(stock) : 0);
		String catId = req.getParameter("categoryId");
		if (catId != null && !catId.isBlank()) {
			Category cat = new Category();
			cat.setId(Integer.parseInt(catId));
			p.setCategory(cat);
		}
		return p;
	}

	private void validate(Product p) throws ValidationException {
		if (p.getName() == null || p.getName().trim().isEmpty())
			throw new ValidationException("Product name is required.");
		if (p.getName().trim().length() > 150)
			throw new ValidationException("Product name must be 150 characters or less.");
		if (p.getPrice() <= 0)
			throw new ValidationException("Price must be greater than 0.");
		if (p.getStock() < 0)
			throw new ValidationException("Stock cannot be negative.");
		if (p.getCategory() != null
				&& (p.getCategory().getId() <= 0 || categoryDAO.findById(p.getCategory().getId()) == null))
			throw new ValidationException("Choose an existing category.");
	}

	private int parseInt(HttpServletRequest req, String param) {
		String value = req.getParameter(param);
		if (value == null)
			return 0;
		try {
			return Integer.parseInt(value.trim());
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	private String getProductName(int productId) {
		Product product = productDAO.getProductById(productId);
		return product == null ? null : product.getName();
	}

	private String base(HttpServletRequest req) {
		return req.getContextPath() + "/admin/products";
	}
}