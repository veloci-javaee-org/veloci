package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import database.DBConnection;
import models.Category;

public class CategoryDAOImpl implements CategoryDAO {
	private static final Logger LOGGER = Logger.getLogger(CategoryDAOImpl.class.getName());

	@Override
	public List<Category> findAll() {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT id, name, description FROM categories ORDER BY name";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next())
				list.add(mapRow(rs));

		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load categories.", e);
			throw new IllegalStateException("Could not load categories.", e);
		}
		return list;
	}

	@Override
	public Category findById(int id) {
		String sql = "SELECT id, name, description FROM categories WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return mapRow(rs);
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not load category " + id, e);
			throw new IllegalStateException("Could not load category.", e);
		}
		return null;
	}

	@Override
	public boolean existsByName(String name, int excludeId) {
		String sql = "SELECT COUNT(*) FROM categories WHERE name = ? AND id <> ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, name);
			ps.setInt(2, excludeId); // -1 when creating = excludes nothing
			try (ResultSet rs = ps.executeQuery()) {
				rs.next();
				return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not check for duplicate category name.", e);
			throw new IllegalStateException("Could not check category name.", e);
		}
	}

	@Override
	public int countProducts(int categoryId) {
		String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, categoryId);
			try (ResultSet rs = ps.executeQuery()) {
				rs.next();
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not count products in category " + categoryId, e);
			throw new IllegalStateException("Could not count category products.", e);
		}
	}

	@Override
	public void insert(Category category) {
		String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, category.getName().trim());
			ps.setString(2, category.getDescription());
			if (ps.executeUpdate() != 1) {
				throw new SQLException("Category insert did not create a row.");
			}

		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not insert category.", e);
			throw new IllegalStateException("Could not insert category.", e);
		}
	}

	@Override
	public void update(Category category) {
		String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, category.getName().trim());
			ps.setString(2, category.getDescription());
			ps.setInt(3, category.getId());
			if (ps.executeUpdate() != 1) {
				throw new SQLException("Category was not found for update.");
			}

		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not update category " + category.getId(), e);
			throw new IllegalStateException("Could not update category.", e);
		}
	}

	@Override
	public void delete(int id) {
		String sql = "DELETE FROM categories WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			if (ps.executeUpdate() != 1) {
				throw new SQLException("Category was not found for deletion.");
			}

		} catch (SQLException e) {
			LOGGER.log(Level.SEVERE, "Could not delete category " + id, e);
			throw new IllegalStateException("Could not delete category.", e);
		}
	}

	private Category mapRow(ResultSet rs) throws SQLException {
		Category c = new Category();
		c.setId(rs.getInt("id"));
		c.setName(rs.getString("name"));
		c.setDescription(rs.getString("description"));
		return c;
	}
}