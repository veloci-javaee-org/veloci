package models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import java.util.List;

import enums.OrderStatus;

public class Order {

	private int id;
	private Customer customer;
	private OrderStatus status;
	private LocalDateTime orderDate;
	private double totalPrice;
	private List<OrderItem> orderItems;

	public Order() {

	}

	public Order(int id, Customer customer, List<OrderItem> orderItems, OrderStatus status, LocalDateTime orderDate, double totalPrice) {
		super();
		this.id = id;
		this.customer = customer;
		this.orderItems = orderItems;
		this.status = status;
		this.orderDate = orderDate;
		this.totalPrice = totalPrice;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public OrderStatus getStatus() {
		return status;
	}

	public void setStatus(OrderStatus status) {
		this.status = status;
	}

	public LocalDateTime getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDateTime orderDate) {
		this.orderDate = orderDate;
	}

	public double getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public List<OrderItem> getOrderItems() {
		return orderItems;
	}

	public void setOrderItems(List<OrderItem> orderItems) {
		this.orderItems = orderItems;
	}
	
	public String getFormattedOrderDate() {
	    if (this.orderDate == null) {
	        return "Unknown";
	    }
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
	    return this.orderDate.format(formatter);
	}

}
