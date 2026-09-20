package listeners;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import database.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.PasswordHasher;

@WebListener
public class SeedDataListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                seedUsers(conn);
                seedCustomers(conn);
                seedCategories(conn);
                seedProducts(conn);
                seedProductImages(conn);
                conn.commit();
                event.getServletContext().log("Seed check complete.");
            } catch (SQLException e) {
                conn.rollback();
                event.getServletContext().log("Seed failed, rolled back.", e);
            }
        } catch (SQLException e) {
            event.getServletContext().log("Seed could not connect.", e);
        }
    }

    private void seedUsers(Connection conn) throws SQLException {
        if (rowCount(conn, "users") > 0) return;

        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            insertUser(ps, "admin", "admin123", "ADMIN");
            insertUser(ps, "ahmed.ali", "password123", "CUSTOMER");
            insertUser(ps, "sara.mohamed", "password123", "CUSTOMER");
        }
    }

    private void insertUser(PreparedStatement ps, String u, String raw, String role) throws SQLException {
        ps.setString(1, u);
        ps.setString(2, PasswordHasher.hash(raw)); // ✅ store hashed, matches login
        ps.setString(3, role);
        ps.executeUpdate();
    }

    private void seedCustomers(Connection conn) throws SQLException {
        if (rowCount(conn, "customers") > 0) return;

        // look up user ids by username so this survives a fresh DB with different auto-increment
        int ahmedId = userIdByUsername(conn, "ahmed.ali");
        int saraId  = userIdByUsername(conn, "sara.mohamed");

        String sql = "INSERT INTO customers (user_id, name, email, address, phone) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ahmedId);
            ps.setString(2, "Ahmed Ali");
            ps.setString(3, "ahmed.ali@email.com");
            ps.setString(4, "15 Tahrir Square, Cairo, Egypt");
            ps.setString(5, "01012345678");
            ps.executeUpdate();

            ps.setInt(1, saraId);
            ps.setString(2, "Sara Mohamed");
            ps.setString(3, "sara.m@email.com");
            ps.setString(4, "42 Corniche El Nil, Alexandria, Egypt");
            ps.setString(5, "01198765432");
            ps.executeUpdate();
        }
    }

    private void seedCategories(Connection conn) throws SQLException {
        if (rowCount(conn, "categories") > 0) return;
        String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "Electronics");      ps.setString(2, "Gadgets, phones, and devices"); ps.executeUpdate();
            ps.setString(1, "Clothing");         ps.setString(2, "Fashion and Egyptian cotton apparel"); ps.executeUpdate();
            ps.setString(1, "Home Appliances");  ps.setString(2, "Kitchen and home essentials"); ps.executeUpdate();
        }
    }

    private void seedProducts(Connection conn) throws SQLException {
        if (rowCount(conn, "products") > 0) return;

        int electronics = categoryIdByName(conn, "Electronics");
        int clothing    = categoryIdByName(conn, "Clothing");
        int appliances  = categoryIdByName(conn, "Home Appliances");

        String sql = "INSERT INTO products (name, price, stock, description, category_id) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            insertProduct(ps, "Samsung Galaxy A54", 12000.00, 15, "Latest mid-range smartphone with great camera", electronics);
            insertProduct(ps, "Egyptian Cotton T-Shirt", 350.00, 50, "100% authentic premium Egyptian cotton, white", clothing);
            insertProduct(ps, "Philips Air Fryer", 3500.00, 8, "Healthy cooking with little to no oil, 4.1L capacity", appliances);
        }
    }

    private void insertProduct(PreparedStatement ps, String n, double p, int s, String d, int cid) throws SQLException {
        ps.setString(1, n); ps.setDouble(2, p); ps.setInt(3, s); ps.setString(4, d); ps.setInt(5, cid);
        ps.executeUpdate();
    }

    private void seedProductImages(Connection conn) throws SQLException {
        if (rowCount(conn, "product_images") > 0) return;
        String sql = "INSERT INTO product_images (product_id, image_path) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            linkImage(ps, conn, "Samsung Galaxy A54", "/images/products/phone.jpg");
            linkImage(ps, conn, "Egyptian Cotton T-Shirt", "/images/products/tshirt.jpg");
            linkImage(ps, conn, "Philips Air Fryer", "/images/products/airfryer.jpg");
        }
    }

    private void linkImage(PreparedStatement ps, Connection conn, String productName, String path) throws SQLException {
        int pid = productIdByName(conn, productName);
        ps.setInt(1, pid); ps.setString(2, path);
        ps.executeUpdate();
    }

    // ---- helpers ----
    private int rowCount(Connection conn, String table) throws SQLException {
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM " + table)) {
            rs.next();
            return rs.getInt(1);
        }
    }

    private int userIdByUsername(Connection conn, String username) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE username = ?")) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        }
    }

    private int categoryIdByName(Connection conn, String name) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM categories WHERE name = ?")) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        }
    }

    private int productIdByName(Connection conn, String name) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM products WHERE name = ?")) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        }
    }
}