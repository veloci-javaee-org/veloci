package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// "/orders" is not mapped here: it belongs to the Orders servlet
@WebServlet(urlPatterns = { "/profile", "/logout" })
public class AccountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String path = req.getServletPath();
		if ("/logout".equals(path)) {
			res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
			return;
		}

		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("username") == null) {
			res.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		String sql = "SELECT c.name, c.email, c.phone, c.address FROM customers c "
				+ "JOIN users u ON u.id = c.user_id WHERE u.username = ?";
		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(sql)) {
			statement.setString(1, (String) session.getAttribute("username"));
			try (ResultSet result = statement.executeQuery()) {
				if (result.next()) {
					req.setAttribute("profileName", result.getString("name"));
					req.setAttribute("profileEmail", result.getString("email"));
					req.setAttribute("profilePhone", result.getString("phone"));
					req.setAttribute("profileAddress", result.getString("address"));
				}
			}
		} catch (SQLException e) {
			throw new ServletException("Could not load profile.", e);
		}
		req.getRequestDispatcher("/WEB-INF/views/customer/profile.jsp").forward(req, res);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		if (!"/logout".equals(req.getServletPath())) {
			res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
			return;
		}
		HttpSession session = req.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		res.sendRedirect(req.getContextPath() + "/home");
	}
}