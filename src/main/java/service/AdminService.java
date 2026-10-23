package service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import dao.CustomerDao;
import dao.OrderDAO;
import database.DBConnection;
import enums.OrderStatus;
import exceptions.CustomerNotFoundException;
import exceptions.DBException;
import exceptions.OrderNotFoundException;
import models.Customer;
import models.Order;

public class AdminService {
	
	private OrderDAO orderDao;
	private CustomerDao customerDao;
	
	public AdminService(OrderDAO orderDao, CustomerDao customerDao) {
		this.orderDao = orderDao;
		this.customerDao = customerDao;
	}
	
	
	public Order getOrderById(int id) {
		
		Connection conn = null;
		try {
		conn = DBConnection.getConnection();
		conn.setAutoCommit(false);
		Optional<Order> order = orderDao.findById(conn, id);
		if(order.isEmpty())
			throw new OrderNotFoundException("Order not found");
		return order.get();
		}
		catch(SQLException e) {
			e.printStackTrace();
			try {
			if(conn != null) conn.rollback();
			}
			catch(SQLException ex) {
				ex.printStackTrace();
			}
		}
		finally {
			if(conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		throw new DBException("Data issue");
		
	}
	
	public List<Order> getOrders(){
		Connection conn = null;
		List<Order> orders = new ArrayList<>();
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			orders.addAll(orderDao.findAll(conn));
			return orders;
		}
		catch(SQLException e) {
			e.printStackTrace();
			if(conn != null) {
				try {
					conn.rollback();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		finally {
			try {
				if(conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			}
			catch(SQLException ex) {
				ex.printStackTrace();
			}
		}
		
		throw new DBException("Data issue");
	}

	public void updateOrderStatus(int id, OrderStatus status) {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			Optional<Order> order = orderDao.findById(conn, id);
			if(order.isEmpty())
				throw new OrderNotFoundException("Order not found");
			orderDao.updateStatus(conn, id, status);
		}
		
		catch(SQLException e) {
			e.printStackTrace();
			if(conn != null) {
				try {
					conn.rollback();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		
		finally {
			if(conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
	}
	
	public Customer getCustomerById(int id) {
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			Optional<Customer> customer = customerDao.findById(conn, id);
			if(customer.isEmpty())
				throw new CustomerNotFoundException("Customer not found");
			return customer.get();
		}
		
		catch(SQLException e) {
			e.printStackTrace();
			if(conn != null) {
				try {
					conn.rollback();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		
		finally {
			if(conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		throw new DBException("Data issue");
	}
	
	
	public List<Customer> getCustomers(){
		Connection conn = null;
		List<Customer> customers = new ArrayList<>();
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			customers.addAll(customerDao.findAll(conn));
			return customers;
		}
		catch(SQLException e) {
			e.printStackTrace();
			if(conn != null) {
				try {
					conn.rollback();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		finally {
			try {
				if(conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			}
			catch(SQLException ex) {
				ex.printStackTrace();
			}
		}
		
		throw new DBException("Data issue");
	}
	
	public List<Order> getOrdersByCustomerId(int id){
		Connection conn = null;
		List<Order> orders = new ArrayList<>();
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			orders.addAll(orderDao.findOrdersByCustomerId(conn,id));
			return orders;
		}
		catch(SQLException e) {
			e.printStackTrace();
			if(conn != null) {
				try {
					conn.rollback();
				}
				catch(SQLException ex) {
					ex.printStackTrace();
				}
			}
		}
		finally {
			try {
				if(conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			}
			catch(SQLException ex) {
				ex.printStackTrace();
			}
		}
		
		throw new DBException("Data issue");
	}
}
