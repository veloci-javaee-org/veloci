package models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import enums.OrderStatus;

public class Order {

	private int id;
	private Customer customer;
	private OrderStatus status;
	private LocalDateTime orderDate;
	private double totalPrice;
	private List<OrderItem> orderItems = new ArrayList<>();

	// NEW
	private String shippingPhone;
	private String shippingAddress;

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

	// NEW: delivery details saved with the order
	public String getShippingPhone() {
		return shippingPhone;
	}

	public void setShippingPhone(String shippingPhone) {
		this.shippingPhone = shippingPhone;
	}

	public String getShippingAddress() {
		return shippingAddress;
	}

	public void setShippingAddress(String shippingAddress) {
		this.shippingAddress = shippingAddress;
	}

	// NEW: calculated, not stored
	public double getSubtotal() {
		double sum = 0;
		if (orderItems != null) {
			for (OrderItem item : orderItems) {
				sum += item.getLineTotal();
			}
		}
		return sum;
	}

	// NEW: what was charged for shipping = total minus the items
	public double getShipping() {
		return totalPrice - getSubtotal();
	}

	// NEW: fmt:formatDate can't format LocalDateTime, so the JSP prints this
	public String getOrderDateFormatted() {
		return orderDate == null ? "" : orderDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm"));
	}

}