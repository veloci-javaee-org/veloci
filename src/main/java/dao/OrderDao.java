package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import models.Order;
import models.OrderSummary;

public interface OrderDao {
	//List<Order> getOrdersById(int id);
	public int findCustomerIdByUsername(Connection conn, String username) throws SQLException;
	int createOrder(String username, String phone, String address, List<Map<String, Object>> items) throws SQLException;
	List<OrderSummary> findOrdersByUsername(String username) throws SQLException;
	Order findOrderDetails(int orderId, String username) throws SQLException;
}
