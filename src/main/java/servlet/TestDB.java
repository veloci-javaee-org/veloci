package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TestDB extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        
        try {
            // 1. Try to get the connection
            Connection conn = DBConnection.getConnection();
            
            // 2. Run a simple query to count products
            String sql = "SELECT COUNT(*) AS total FROM products";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            int count = 0;
            if (rs.next()) {
                count = rs.getInt("total");
            }
            
            // 3. If we get here, the connection is SUCCESSFUL!
            response.getWriter().println("<h1 style='color:green;'>✅ DATABASE CONNECTION SUCCESSFUL!</h1>");
            response.getWriter().println("<p>Successfully connected to <b>veloci_db</b>.</p>");
            response.getWriter().println("<p>Found <b>" + count + "</b> products in the database.</p>");
            response.getWriter().println("<p><a href='/Veloci/products'>Go to Products Page</a></p>");
            
            conn.close(); // Always close the connection
            
        } catch (SQLException e) {
            // 4. If we get here, the connection FAILED. This will tell us exactly why.
            response.setContentType("text/html");
            response.getWriter().println("<h1 style='color:red;'>❌ DATABASE CONNECTION FAILED</h1>");
            response.getWriter().println("<p>Check the Tomcat Console for the exact error.</p>");
            response.getWriter().println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(); // This prints the detailed error to the Eclipse Console
        }
    }
}