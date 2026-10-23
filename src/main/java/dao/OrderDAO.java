package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import enums.OrderStatus;
import models.Order;

public interface OrderDAO {
	void updateStatus(Connection conn, int id, OrderStatus status) throws SQLException;
	
	Optional<Order> findById(Connection conn, int id) throws SQLException;
	
	List<Order> findAll(Connection conn) throws SQLException;
	
	List<Order> findOrdersByCustomerId(Connection conn, int id) throws SQLException;
}
