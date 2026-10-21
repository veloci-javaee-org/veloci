package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// CHANGED: "/orders" removed, it now belongs to the Orders servlet
@WebServlet(urlPatterns = { "/profile", "/logout" })
public class AccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            res.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        // CHANGED: the else-branch that forwarded to /views/orders.jsp is gone.
        // Only /profile reaches this point now.
        if ("/profile".equals(path)) {
            String sql = "SELECT c.name, c.email, c.phone, c.address "
                       + "FROM customers c JOIN users u ON u.id = c.user_id "
                       + "WHERE u.username = ?";

            try (Connection c = DBConnection.getConnection();
                 PreparedStatement ps = c.prepareStatement(sql)) {

                ps.setString(1, (String) req.getSession().getAttribute("username"));

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        req.setAttribute("profileName", rs.getString("name"));
                        req.setAttribute("profileEmail", rs.getString("email"));
                        req.setAttribute("profilePhone", rs.getString("phone"));
                        req.setAttribute("profileAddress", rs.getString("address"));
                    }
                }
            } catch (Exception e) {
                throw new ServletException("Could not load profile", e);
            }

            req.getRequestDispatcher("/views/profile.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        res.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}