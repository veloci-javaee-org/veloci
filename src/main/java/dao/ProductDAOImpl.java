package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;

import database.DBConnection;
import models.Category;
import models.Product;
import models.ProductImage;

public class ProductDAOImpl implements ProductDAO {
	private static final Logger LOGGER = Logger.getLogger(ProductDAOImpl.class.getName());

	@Override
	public List<Product> getAllProduct() {
		List<Product> products = new ArrayList<>();
		String sql = "select p.id, p.name, p.price, p.stock, p.description, "
				+ "c.id category_id, c.name category_name, c.description category_description, "
				+ "(select image_path from product_images where product_id = p.id order by id limit 1) as image_path "
				+ "from products p left join categories c on p.category_id = c.id";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next())
				products.add(mapToProductWithImg(rs));
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load products.", e);
			throw new IllegalStateException("Could not load products.", e);
		}
		return products;
	}

	@Override
	public List<Product> searchProductsByName(String keyword) {
		List<Product> products = new ArrayList<>();
		String sql = "select p.id, p.name, p.price, p.stock, p.description, "
				+ "c.id category_id, c.name category_name, c.description category_description, "
				+ "(select image_path from product_images where product_id = p.id order by id limit 1) as image_path "
				+ "from products p left join categories c on p.category_id = c.id " + "where p.name like ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, "%" + keyword + "%");
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next())
					products.add(mapToProductWithImg(rs));
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not search products.", e);
			throw new IllegalStateException("Could not search products.", e);
		}
		return products;
	}

	@Override
	public Product getProductById(int id) {
		// BUG FIX: was "where p.id like ?" — must be "= ?" for an integer PK
		String sql = "select p.id, p.name, p.price, p.stock, p.description, "
				+ "c.id category_id, c.name category_name, c.description category_description "
				+ "from products p left join categories c on p.category_id = c.id " + "where p.id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					Product product = mapToProductWithoutImg(rs);
					product.setImages(getImagesForProduct(conn, id));
					return product;
				}
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load product " + id, e);
			throw new IllegalStateException("Could not load product.", e);
		}
		return null;
	}

	// Admin CRUD
	@Override
	public int insertProduct(Product product) throws SQLException {
		String sql = "insert into products (name, price, stock, description, category_id) values (?,?,?,?,?)";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, product.getName());
			stmt.setDouble(2, product.getPrice());
			stmt.setInt(3, product.getStock());
			stmt.setString(4, product.getDescription());
			if (product.getCategory() != null && product.getCategory().getId() != 0)
				stmt.setInt(5, product.getCategory().getId());
			else
				stmt.setNull(5, java.sql.Types.INTEGER);
			stmt.executeUpdate();
			try (ResultSet keys = stmt.getGeneratedKeys()) {
				if (keys.next())
					return keys.getInt(1);
			}
			throw new SQLException("Product insert did not return a generated id.");
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not insert product.", e);
			throw e;
		}
	}

	@Override
	public boolean updateProduct(Product product) throws SQLException {
		String sql = "update products set name=?, price=?, stock=?, description=?, category_id=? where id=?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setString(1, product.getName());
			stmt.setDouble(2, product.getPrice());
			stmt.setInt(3, product.getStock());
			stmt.setString(4, product.getDescription());
			if (product.getCategory() != null && product.getCategory().getId() != 0)
				stmt.setInt(5, product.getCategory().getId());
			else
				stmt.setNull(5, java.sql.Types.INTEGER);
			stmt.setInt(6, product.getId());
			return stmt.executeUpdate() == 1;
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not update product " + product.getId(), e);
			throw e;
		}
	}

	@Override
	public boolean updateStock(int productId, int newStock) throws SQLException {
		String sql = "update products set stock = ? where id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, newStock);
			stmt.setInt(2, productId);
			return stmt.executeUpdate() == 1;
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not update stock for product " + productId, e);
			throw e;
		}
	}

	@Override
	public boolean deleteProduct(int id) throws SQLException {
		// product_images rows are removed by ON DELETE CASCADE in the schema
		String sql = "delete from products where id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, id);
			return stmt.executeUpdate() == 1;
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not delete product " + id, e);
			throw e;
		}
	}

	// Image management
	@Override
	public void insertImage(int productId, String imagePath) throws SQLException {
		String sql = "insert into product_images (product_id, image_path, is_primary) values (?, ?, false)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, productId);
			stmt.setString(2, imagePath);
			stmt.executeUpdate();
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not save image record for product " + productId, e);
			throw e;
		}
	}

	@Override
	public boolean deleteImage(int imageId) throws SQLException {
		String sql = "delete from product_images where id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, imageId);
			return stmt.executeUpdate() == 1;
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not delete product image " + imageId, e);
			throw e;
		}
	}

	@Override
	public String getImagePathById(int imageId) {
		String sql = "select image_path from product_images where id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, imageId);
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next())
					return rs.getString("image_path");
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load image " + imageId, e);
			throw new IllegalStateException("Could not load product image.", e);
		}
		return null;
	}

	@Override
	public List<ProductImage> getImagesForProduct(int productId) {
		List<ProductImage> images = new ArrayList<>();
		String sql = "select id, product_id, image_path from product_images where product_id = ? order by id";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, productId);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					ProductImage img = new ProductImage();
					img.setId(rs.getInt("id"));
					img.setProductId(rs.getInt("product_id"));
					img.setImagePath(rs.getString("image_path"));
					images.add(img);
				}
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load images for product " + productId, e);
			throw new IllegalStateException("Could not load product images.", e);
		}
		return images;
	}

	/// Private helpers
	private Product mapToProductWithImg(ResultSet res) throws SQLException {
		Product product = mapToProductWithoutImg(res);
		String imagePath = res.getString("image_path");
		if (imagePath != null) {
			ProductImage img = new ProductImage();
			img.setImagePath(imagePath);
			img.setProductId(product.getId());
			List<ProductImage> images = new ArrayList<>();
			images.add(img);
			product.setImages(images);
		} else {
			product.setImages(new ArrayList<>());
		}
		return product;
	}

	private Product mapToProductWithoutImg(ResultSet res) throws SQLException {
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

	// private overload used internally by getProductById (reuses open connection)
	private List<ProductImage> getImagesForProduct(Connection conn, int productId) throws SQLException {
		List<ProductImage> images = new ArrayList<>();
		String sql = "select id, product_id, image_path from product_images where product_id = ?";
		try (PreparedStatement stmt = conn.prepareStatement(sql)) {
			stmt.setInt(1, productId);
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
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