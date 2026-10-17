package dao;

import java.util.List;
import models.Product;
import models.ProductImage;

public interface ProductDAO {

    List<Product> getAllProduct();
    
    List<Product> searchProductsByName(String keyword);
    
    Product getProductById(int id);

    // Admin CRUD
    int insertProduct(Product product);

    void updateProduct(Product product);

    void updateStock(int productId, int newStock);

    void deleteProduct(int id);

    // Image management 
    void insertImage(int productId, String imagePath) throws java.sql.SQLException;

    void deleteImage(int imageId);

    String getImagePathById(int imageId);

    List<ProductImage> getImagesForProduct(int productId);
}