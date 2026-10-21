package models;

import java.sql.Timestamp;

public class OrderSummary {
    private int id;
    private Timestamp orderDate;
    private double totalAmount;
    private String status;
    private String shippingAddress;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
}