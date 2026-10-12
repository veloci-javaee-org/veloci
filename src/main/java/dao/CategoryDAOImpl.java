package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import database.DBConnection;
import models.Category;

public class CategoryDAOImpl implements CategoryDAO {

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
			e.printStackTrace();
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
			e.printStackTrace();
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
			e.printStackTrace();
		}
		return false;
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
			e.printStackTrace();
		}
		return 0;
	}

	
	@Override
	public void insert(Category category) {
		String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, category.getName().trim());
			ps.setString(2, category.getDescription());
			ps.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

	@Override
	public void update(Category category) {
		String sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, category.getName().trim());
			ps.setString(2, category.getDescription());
			ps.setInt(3, category.getId());
			ps.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void delete(int id) {
		String sql = "DELETE FROM categories WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
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