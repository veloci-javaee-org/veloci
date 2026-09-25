package dao;

import java.util.List;

import models.Product;

public interface ProductDAO {
	List<Product> getAllProduct();
	
	List<Product> searchProductsByName(String keyword);
	
	Product getProductById(int id);
}

