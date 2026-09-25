package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Product;

import java.io.IOException;
import java.util.List;

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
        request.setAttribute("products", products);
        request.getRequestDispatcher("/views/products.jsp").forward(request, response);
    }
	
	private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> products = productDAO.searchProductsByName(keyword);
        request.setAttribute("products", products);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/views/products.jsp").forward(request, response);
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
