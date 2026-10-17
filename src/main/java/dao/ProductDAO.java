package dao;

import java.util.List;
import models.Product;
import models.ProductImage;

public interface ProductDAO {

	List<Product> getAllProduct();

	List<Product> searchProductsByName(String keyword);

	Product getProductById(int id);

	// Admin CRUD
	int insertProduct(Product product) throws java.sql.SQLException;

	boolean updateProduct(Product product) throws java.sql.SQLException;

	boolean updateStock(int productId, int newStock) throws java.sql.SQLException;

	boolean deleteProduct(int id) throws java.sql.SQLException;

	// Image management
	void insertImage(int productId, String imagePath) throws java.sql.SQLException;

	boolean deleteImage(int imageId) throws java.sql.SQLException;

	String getImagePathById(int imageId);

	List<ProductImage> getImagesForProduct(int productId);
}