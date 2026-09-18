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

/**
 * Central authorization checkpoint. Runs on every request, before any
 * servlet, so access rules live in exactly one place instead of being
 * duplicated (and potentially forgotten) across individual servlets.
 */
@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    // Pages reachable without being logged in at all.
	private static final Set<String> PUBLIC_PATHS = Set.of(
		    "/", "/index.html",
		    "/views/login.html", "/login",
		    "/views/signup.html", "/signup",
		    "/views/unauthorized.html"
		);

    // Path prefixes that don't need auth checks at all (static assets).
    private static final Set<String> PUBLIC_PREFIXES = Set.of(
        "/css/", "/js/", "/images/"
    );

    // Only ADMIN may reach these.
    private static final Set<String> ADMIN_ONLY_PATHS = Set.of(
        "/admin_panel"
    );

    // Only CUSTOMER may reach these (admins are blocked, per your requirement).
    private static final Set<String> CUSTOMER_ONLY_PATHS = Set.of(
        "/customer_profile"
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (path.isEmpty()) {
            path = "/";
        }

        System.out.println("[AuthorizationFilter] path=" + path
                + " session=" + (request.getSession(false) != null)
                + " role=" + (request.getSession(false) != null ? request.getSession(false).getAttribute("role") : "null"));

        // Static assets and explicitly public pages pass straight through.
        if (PUBLIC_PATHS.contains(path) || startsWithAny(path, PUBLIC_PREFIXES)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("username") != null;

        // Not logged in at all -> send to login, not the 403 page.
        // (403 is reserved for "you're logged in, but not allowed here".)
        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/views/login.html");
            return;
        }

        RoleEnum role = (RoleEnum) session.getAttribute("role");

        if (ADMIN_ONLY_PATHS.contains(path) && !RoleEnum.ADMIN.equals(role)) {
            forbidden(request, response);
            return;
        }

        if (CUSTOMER_ONLY_PATHS.contains(path) && RoleEnum.ADMIN.equals(role)) {
            forbidden(request, response);
            return;
        }

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
        request.getRequestDispatcher("/unauthorized.html").forward(request, response);
    }
}