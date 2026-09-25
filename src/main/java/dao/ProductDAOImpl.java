package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import database.DBConnection;
import models.Category;
import models.Product;
import models.ProductImage;

public class ProductDAOImpl implements ProductDAO {

	@Override
	public List<Product> getAllProduct() {
		List<Product> products = new ArrayList<>();
		
		 String sql = "select p.id, p.name, p.price, p.stock, p.description, "
		 		+ "c.id category_id, c.name category_name, c.description category_description, "
		 		+ "(select image_path from product_images where product_id = p.id limit 1) as image_path "
		 		+ "from products p left join categories c on p.category_id = c.id";
		 
		 try(Connection conn = DBConnection.getConnection();
				 PreparedStatement stmt = conn.prepareStatement(sql);
				 ResultSet rs = stmt.executeQuery()){
			 
			 while(rs.next()) {
				 products.add(mapToProductWithImg(rs));
			 }
		 } catch(SQLException e) {
			 e.printStackTrace();
		 }
		
		return products;
	}

	@Override
	public List<Product> searchProductsByName(String keyword) {
		List<Product> products = new ArrayList<>();
		
		String sql = "Select p.id, p.name, p.price, p.stock, p.description, "
				+ "c.id category_id, c.name category_name, c.description category_description, "
				+ "(select image_path from product_images where product_id = p.id limit 1) as image_path "
				+ "from products p left join categories c on p.category_id = c.id "
				+ "where p.name like ?";
		
		try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {

	            stmt.setString(1, "%" + keyword + "%");

	            try (ResultSet rs = stmt.executeQuery()) {
	                while (rs.next()) {
	                    products.add(mapToProductWithImg(rs));
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
		
		return products;
	}

	@Override
	public Product getProductById(int id) {

		
		String sql = "Select p.id, p.name, p.price, p.stock, p.description, "
				+ "c.id category_id, c.name category_name, c.description category_description "
				+ "from products p left join categories c on p.category_id = c.id "
				+ "where p.id like ?";
		
		try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql)) {

	            stmt.setInt(1, id);

	            try (ResultSet rs = stmt.executeQuery()) {
	                if(rs.next()) {
	                	Product product = mapToProductWithoutImg(rs);
	                	product.setImages(getImagesForProduct(conn, id));
	                	return product;
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
		
		return null;
	}
	
	private Product mapToProductWithImg(ResultSet res) throws SQLException{
		Product product = new Product();
		product.setId(res.getInt("id"));
		product.setName(res.getString("name"));
        product.setPrice(res.getDouble("price"));
        product.setStock(res.getInt("stock"));
        product.setDescription(res.getString("description"));
        
        Category category = new Category();
        category.setId(res.getInt("category_id"));
        category.setName(res.getString("category_name"));
        category.setDescription(res.getString("category_description"));
        
        product.setCategory(category);
        String imagePath = res.getString("image_path");
        
        if(imagePath != null) {
        	ProductImage img = new ProductImage();
        	img.setImagePath(imagePath);
        	img.setProductId(product.getId());
        	
        	List<ProductImage> images = new ArrayList<>();
        	images.add(img);
        	product.setImages(images);
        } else 
        	product.setImages(new ArrayList<>());
		
		return product;
	}
	
	private Product mapToProductWithoutImg(ResultSet res) throws SQLException{
		Product product = new Product();
		product.setId(res.getInt("id"));
		product.setName(res.getString("name"));
        product.setPrice(res.getDouble("price"));
        product.setStock(res.getInt("stock"));
        product.setDescription(res.getString("description"));
        
        Category category = new Category();
        category.setId(res.getInt("category_id"));
        category.setName(res.getString("category_name"));
        category.setDescription(res.getString("category_description"));
        
        product.setCategory(category);
        
        product.setImages(new ArrayList<>());
		
		return product;
	}
	
	private List<ProductImage> getImagesForProduct (Connection conn, int productId) throws SQLException {
		List<ProductImage> images = new ArrayList<>();
		String sql = "select id, product_id, image_path from product_images where product_id = ?";
		
		try(PreparedStatement stmt = conn.prepareStatement(sql)){
			stmt.setInt(1, productId);
			try(ResultSet rs = stmt.executeQuery()){
				while(rs.next()) {
					ProductImage img = new ProductImage();
					img.setId(rs.getInt("id"));
					img.setProductId(rs.getInt("product_id"));
					img.setImagePath(rs.getString("image_path"));
					
					images.add(img);
				}
			}
		}
		
		return images;
	}

}
