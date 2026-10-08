package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product;

import java.io.IOException;
import java.util.List;
import java.util.Comparator;

import dao.ProductDAO;
import dao.ProductDAOImpl;

/**
 * Servlet implementation class ProductServlet
 */
//@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductDAO productDAO;
	
	

    @Override
	public void init() throws ServletException {
		productDAO = new ProductDAOImpl();
	}


	public ProductServlet() {
       
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		
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
        products.removeIf(p -> p.getCategory() == null || !"Clothing".equalsIgnoreCase(p.getCategory().getName()));
        if (keyword != null && !keyword.isBlank()) products.removeIf(p -> !p.getName().toLowerCase().contains(keyword.toLowerCase()));
        if (category != null && !category.isBlank()) products.removeIf(p -> !category.equalsIgnoreCase(p.getCategory().getName()));
        if ("price_asc".equals(sort)) products.sort(Comparator.comparingDouble(Product::getPrice));
        else if ("price_desc".equals(sort)) products.sort(Comparator.comparingDouble(Product::getPrice).reversed());
        else if ("name".equals(sort)) products.sort(Comparator.comparing(Product::getName, String.CASE_INSENSITIVE_ORDER));
        request.setAttribute("products", products);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("sort", sort);
        request.getRequestDispatcher("/views/products.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(id);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/views/product-details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
