package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import database.DBConnection;
import enums.OrderStatus;
import mapper.OrderMapper;
import models.Order;
import models.OrderItem;
import models.OrderSummary;
import models.Product;

public class OrderDaoImpl implements OrderDao {

    @Override
    public int findCustomerIdByUsername(Connection conn, String username) throws SQLException {
        String sql = "SELECT c.id FROM customers c "
                   + "JOIN users u ON u.id = c.user_id "
                   + "WHERE u.username = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
                throw new SQLException("No customer found for user: " + username);
            }
        }
    }

    @Override
    public int createOrder(String username, String phone, String address,
                           List<Map<String, Object>> items) throws SQLException {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                int customerId = findCustomerIdByUsername(con, username);

                double subtotal = 0;
                for (Map<String, Object> item : items) {
                    subtotal += (Double) item.get("lineTotal");
                }
                double total = subtotal + 50.0;   // same flat shipping as /checkout

                int orderId = insertOrder(con, customerId, total, phone, address);
                insertOrderItems(con, orderId, items);

                con.commit();
                return orderId;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    private void insertOrderItems(Connection con, int orderId,
                                  List<Map<String, Object>> items) throws SQLException {
        String itemSql = "INSERT INTO order_items (order_id, product_id, size, quantity, price) "
                       + "VALUES (?, ?, ?, ?, ?)";
        String stockSql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

        try (PreparedStatement itemPs = con.prepareStatement(itemSql);
             PreparedStatement stockPs = con.prepareStatement(stockSql)) {

            for (Map<String, Object> item : items) {
                Product product = (Product) item.get("product");
                int quantity = (Integer) item.get("quantity");
                String size = (String) item.get("size");
                if (size == null) {
                    size = "";   // safety net: the column is NOT NULL
                }

                // 1. save the line
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, product.getId());
                itemPs.setString(3, size);
                itemPs.setInt(4, quantity);
                itemPs.setDouble(5, product.getPrice());
                itemPs.executeUpdate();

                // 2. reduce stock, only if enough is left
                stockPs.setInt(1, quantity);
                stockPs.setInt(2, product.getId());
                stockPs.setInt(3, quantity);
                int updated = stockPs.executeUpdate();
                if (updated == 0) {
                    throw new SQLException("Not enough stock for: " + product.getName());
                }
            }
        }
    }

    private int insertOrder(Connection con, int customerId, double total,
                            String phone, String address) throws SQLException {
        String sql = "INSERT INTO orders (customer_id, total_amount, shipping_phone, shipping_address) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setDouble(2, total);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("Order insert returned no id");
            }
        }
    }

    @Override
    public List<OrderSummary> findOrdersByUsername(String username) throws SQLException {
        String sql = "SELECT o.id, o.order_date, o.total_amount, o.status, o.shipping_address "
                   + "FROM orders o "
                   + "JOIN customers c ON c.id = o.customer_id "
                   + "JOIN users u ON u.id = c.user_id "
                   + "WHERE u.username = ? "
                   + "ORDER BY o.id DESC";
        List<OrderSummary> orders = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderSummary o = new OrderSummary();
                    o.setId(rs.getInt("id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setShippingAddress(rs.getString("shipping_address"));
                    orders.add(o);
                }
            }
        }
        return orders;
    }

    @Override
    public Order findOrderDetails(int orderId, String username) throws SQLException {
        String orderSql = "SELECT o.id, o.order_date, o.total_amount, o.status, "
                        + "o.shipping_phone, o.shipping_address "
                        + "FROM orders o "
                        + "JOIN customers c ON c.id = o.customer_id "
                        + "JOIN users u ON u.id = c.user_id "
                        + "WHERE o.id = ? AND u.username = ?";

        String itemsSql = "SELECT id, product_id, size, quantity, price "
                        + "FROM order_items WHERE order_id = ? ORDER BY id";

        try (Connection con = DBConnection.getConnection()) {
            Order order = new Order();

            try (PreparedStatement ps = con.prepareStatement(orderSql)) {
                ps.setInt(1, orderId);
                ps.setString(2, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;   // not found, or it belongs to someone else
                    }
                    order.setId(rs.getInt("id"));
                    order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                    order.setTotalPrice(rs.getDouble("total_amount"));
                    order.setShippingPhone(rs.getString("shipping_phone"));
                    order.setShippingAddress(rs.getString("shipping_address"));

                    String statusText = rs.getString("status");
                    for (OrderStatus s : OrderStatus.values()) {
                        if (s.name().equalsIgnoreCase(statusText)) {
                            order.setStatus(s);
                        }
                    }
                }
            }

            ProductDAOImpl productDao = new ProductDAOImpl();
            try (PreparedStatement ps = con.prepareStatement(itemsSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        OrderItem item = new OrderItem();
                        item.setId(rs.getInt("id"));
                        item.setProduct(productDao.getProductById(rs.getInt("product_id")));
                        item.setSize(rs.getString("size"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        order.getOrderItems().add(item);
                    }
                }
            }
            return order;
        }
    }
    
    @Override
	public void updateStatus(Connection conn, int id, OrderStatus status) throws SQLException {
		String sql = "UPDATE orders o SET o.status = ? WHERE o.id = ? ";
		
		try(PreparedStatement ps = conn.prepareStatement(sql)){
			ps.setString(1, status.toString());
			ps.setInt(2, id);
			ps.executeUpdate();
		}
		
	}

	@Override
	public Optional<Order> findById(Connection conn, int id) throws SQLException {
		String sql = """
					SELECT 
					o.id AS order_id
					, o.order_date
					, o.total_amount
					, o.status
					, o.customer_id
					, c.name AS customer_name
					, c.address
					, i.id AS item_id
					, i.quantity
					, i.price
					, p.id AS product_id
					, p.name AS product_name
					, p.description
					FROM orders o
					join customers c on o.customer_id = c.id
					join order_items i on i.order_id = o.id
					join products p on i.product_id = p.id
					WHERE o.id = ?
					 """;
		
		try(PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try(ResultSet rs = ps.executeQuery()){
				if(rs.next())
					return Optional.ofNullable(OrderMapper.resultSetToDto(rs));
			}
			
		}
		return Optional.empty();
	}

	@Override
	public List<Order> findAll(Connection conn) throws SQLException {
		String sql = """
				SELECT o.id, o.order_date, o.total_amount, o.status, o.customer_id
				FROM orders o
				 """;
		List<Order> orders = new ArrayList<>();
		
		try(PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while(rs.next()) {
				orders.add(OrderMapper.resultSetToEntity(rs));
			}
			
		}
		return orders;
	}
	
	
	@Override
	public List<Order> findOrdersByCustomerId(Connection conn, int id) throws SQLException{
		String sql = """
				SELECT 
				o.id 
    			, o.order_date
    			, o.total_amount
    			, o.status
    			, o.customer_id
    			FROM customers c
    			join orders o on o.customer_id = c.id
    			WHERE c.id = ?
				""";
		List<Order> orders = new ArrayList<>();
		try(PreparedStatement ps = conn.prepareStatement(sql)){
			ps.setInt(1, id);
			try(ResultSet rs = ps.executeQuery()){
				while(rs.next()) {
				orders.add(OrderMapper.resultSetToEntity(rs));
				}
			}
		}
		
		return orders;
	}

}