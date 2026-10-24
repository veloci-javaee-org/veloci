package filter;

import java.io.IOException;
import java.util.Set;

import enums.RoleEnum;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/", "/home",
            "/login", "/signup",
            "/products", "/search", "/product-details",
            "/logout","/not-found","/data-issue");

    private static final Set<String> PUBLIC_PREFIXES = Set.of(
            "/css/", "/js/", "/images/");

    private static final Set<String> CUSTOMER_ONLY_PATHS = Set.of(
            "/profile", "/orders", "/checkout", "/PlaceOrder", "/order-success", "/order-details");


    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;


        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (path.isEmpty()) {
            path = "/";
        }

        if ("/".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("/index.jsp".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (path.startsWith("/views/") && path.endsWith(".jsp")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (PUBLIC_PATHS.contains(path) || startsWithAny(path, PUBLIC_PREFIXES)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("username") != null;
        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object role = session.getAttribute("role");
        boolean adminPath = "/admin".equals(path) || path.startsWith("/admin/")
                || "/test-db".equals(path);
        if (adminPath && !RoleEnum.ADMIN.equals(role)) {
            forbidden(request, response);
            return;
        }

        boolean customerPath = CUSTOMER_ONLY_PATHS.contains(path);
        if (customerPath && !RoleEnum.CUSTOMER.equals(role)) {
            forbidden(request, response);
            return;
        }

        System.out.println("[AuthorizationFilter] path=" + path
                + " session=" + (request.getSession(false) != null)
                + " role=" + (request.getSession(false) != null ? request.getSession(false).getAttribute("role") : "null"));

        chain.doFilter(req, res);
    }

    private boolean startsWithAny(String path, Set<String> prefixes) {
        for (String prefix : prefixes) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    private void forbidden(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        request.getRequestDispatcher("/WEB-INF/views/errors/unauthorized.html").forward(request, response);
    }
}