package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import enums.OrderStatus;
import models.Order;
import models.OrderSummary;

public interface OrderDao {
	//List<Order> getOrdersById(int id);
	public int findCustomerIdByUsername(Connection conn, String username) throws SQLException;
	int createOrder(String username, String phone, String address, List<Map<String, Object>> items) throws SQLException;
	List<OrderSummary> findOrdersByUsername(String username) throws SQLException;
	Order findOrderDetails(int orderId, String username) throws SQLException;
	
	void updateStatus(Connection conn, int id, OrderStatus status) throws SQLException;
	
	Optional<Order> findById(Connection conn, int id) throws SQLException;
	
	List<Order> findAll(Connection conn) throws SQLException;
	
	List<Order> findOrdersByCustomerId(Connection conn, int id) throws SQLException;
}
