package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import enums.OrderStatus;
import mapper.OrderMapper;
import models.Order;

public class OrderDAOImpl implements OrderDAO{

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
