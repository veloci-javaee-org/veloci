package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

import database.DBConnection;
import enums.RoleEnum;
import models.AuthenticatedUser;
import models.User;


public class UserDaoImpl implements UserDao {

    @Override
    public int insert(Connection conn, User user) throws SQLException {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole().toString());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
                throw new SQLException("Insert into users did not return a generated id.");
            }
        }
    }

    @Override
    public boolean existsByUsername(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public Optional<AuthenticatedUser> findAuthenticatedUserByIdentifier(String identifier) throws SQLException {
        // LEFT JOIN because an admin has a users row but no matching customers row at all.
        // COALESCE falls back to username as the display name when there's no customer profile.
        String sql = "SELECT u.username, u.password, u.role, " +
                     "COALESCE(c.name, u.username) AS name, c.email " +
                     "FROM users u " +
                     "LEFT JOIN customers c ON c.user_id = u.id " +
                     "WHERE u.username = ? OR c.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AuthenticatedUser user = new AuthenticatedUser(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("name"),
                        rs.getString("email"), // null for admins, that's fine
                        RoleEnum.valueOf(rs.getString("role"))
                    );
                    return Optional.of(user);
                }
                return Optional.empty();
            }
        }
    }
}