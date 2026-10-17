package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import dao.ProductDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Product;

/**
 * Session-based shopping cart.
 *
 * POST /cart  action=add    productId, size, quantity
 *             action=update index, quantity   (quantity < 1 removes the line)
 *             action=remove index
 * GET  /cart  full cart page (/views/cart.jsp)
 *
 * AJAX requests (X-Requested-With: XMLHttpRequest) get back only the
 * refreshed drawer HTML; normal requests are redirected to the cart page.
 */
@WebServlet("/cart")
public class Cart extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String SIZES = "XS|S|M|L|XL|XXL";
    private static final String DRAWER_ITEMS = "/views/cart-drawer-items.jsp";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "add";
        }

        HttpSession session = req.getSession();
        List<Map<String, Object>> items = getItems(session);

        switch (action) {
            case "add":
                if (!add(req, items)) {
                    // Invalid product / size: send the user back to the shop
                    if (isAjax(req)) {
                        res.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    } else {
                        res.sendRedirect(req.getContextPath() + "/products");
                    }
                    return;
                }
                break;
            case "update":
                update(req, items);
                break;
            case "remove":
                remove(req, items);
                break;
            default:
                break;
        }

        if (isAjax(req)) {
            res.setHeader("Cache-Control", "no-store");
            req.getRequestDispatcher(DRAWER_ITEMS).forward(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<Map<String, Object>> items = getItems(req.getSession());
        double total = 0;
        for (Map<String, Object> item : items) {
            total += (Double) item.get("lineTotal");
        }
        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.getRequestDispatcher("/views/cart.jsp").forward(req, res);
    }

    // ---------------------------------------------------------------- actions

    private boolean add(HttpServletRequest req, List<Map<String, Object>> items) {
        Product product = new ProductDAOImpl().getProductById(parse(req.getParameter("productId"), 0));
        if (product == null || product.getStock() <= 0) {
            return false;
        }
        String size = req.getParameter("size");
        if (size == null || !size.matches(SIZES)) {
            return false;
        }
        int quantity = Math.max(1, parse(req.getParameter("quantity"), 1));

        // Same product + same size -> increase the existing line instead of duplicating
        for (Map<String, Object> item : items) {
            Product p = (Product) item.get("product");
            if (String.valueOf(p.getId()).equals(String.valueOf(product.getId()))
                    && size.equals(item.get("size"))) {
                setQuantity(item, (Integer) item.get("quantity") + quantity);
                return true;
            }
        }

        Map<String, Object> item = new LinkedHashMap<>();
        item.put("product", product);
        item.put("size", size);
        item.put("quantity", 1);
        item.put("lineTotal", 0.0);
        setQuantity(item, quantity);
        items.add(item);
        return true;
    }

    private void update(HttpServletRequest req, List<Map<String, Object>> items) {
        int index = parse(req.getParameter("index"), -1);
        if (index < 0 || index >= items.size()) {
            return;
        }
        int quantity = parse(req.getParameter("quantity"), 1);
        if (quantity < 1) {
            items.remove(index);
        } else {
            setQuantity(items.get(index), quantity);
        }
    }

    private void remove(HttpServletRequest req, List<Map<String, Object>> items) {
        int index = parse(req.getParameter("index"), -1);
        if (index >= 0 && index < items.size()) {
            items.remove(index);
        }
    }

    // ---------------------------------------------------------------- helpers

    /** Caps the quantity at the product's stock and recalculates the line total. */
    private void setQuantity(Map<String, Object> item, int quantity) {
        Product product = (Product) item.get("product");
        int q = Math.max(1, Math.min(product.getStock(), quantity));
        item.put("quantity", q);
        item.put("lineTotal", product.getPrice() * q);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> getItems(HttpSession session) {
        List<Map<String, Object>> items = (List<Map<String, Object>>) session.getAttribute("cartItems");
        if (items == null) {
            items = new ArrayList<>();
            session.setAttribute("cartItems", items);
        }
        return items;
    }

    private boolean isAjax(HttpServletRequest req) {
        return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
    }

    private int parse(String value, int fallback) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return fallback;
        }
    }
}
