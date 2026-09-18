package servlet;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet implementation class AdminPanel.
 * Access control (login + ADMIN-only role check) is handled centrally by
 * AuthorizationFilter. admin_panel.html lives under WEB-INF/views so it can
 * NEVER be requested directly by a browser -- only reachable through this
 * servlet's forward, which only runs after the filter has already approved
 * the request.
 */

@WebServlet("/admin_panel")
public class AdminPanel extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin_panel.html").forward(request, response);
    }
}