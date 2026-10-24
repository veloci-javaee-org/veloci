package mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import enums.OrderStatus;
import models.Customer;
import models.Order;
import models.OrderItem;
import models.Product;

public class OrderMapper {
	
	private OrderMapper() {}

	public static Order resultSetToEntity(ResultSet rs) throws SQLException {
		Order order = new Order();
		Customer customer = new Customer();
		
		order.setId(rs.getInt("id"));
		order.setTotalPrice(rs.getDouble("total_amount"));
		order.setStatus(OrderStatus.valueOf(rs.getString("status").toUpperCase()));
		order.setOrderDate(rs.getObject("order_date", LocalDateTime.class));
		customer.setId(rs.getInt("customer_id"));
		order.setCustomer(customer);
		
		return order;
	};
	
	public static Order resultSetToDto(ResultSet rs) throws SQLException {
		Order order = new Order();
		Customer customer = new Customer();
		List<OrderItem> items = new ArrayList<>();
		
		
		order.setId(rs.getInt("order_id"));
		order.setTotalPrice(rs.getDouble("total_amount"));
		order.setStatus(OrderStatus.valueOf(rs.getString("status").toUpperCase()));
		order.setOrderDate(rs.getObject("order_date", LocalDateTime.class));
		customer.setId(rs.getInt("customer_id"));
		customer.setName(rs.getString("customer_name"));
		customer.setAddress(rs.getString("address"));
		order.setCustomer(customer);
		
		do {
			OrderItem item = new OrderItem();
			Product product = new Product();
			item.setId(rs.getInt("item_id"));
			item.setPrice(rs.getDouble("price"));
			item.setQuantity(rs.getInt("quantity"));
			product.setId(rs.getInt("product_id"));
			product.setName(rs.getString("product_name"));
			product.setDescription(rs.getString("description"));
			item.setProduct(product);
			items.add(item);
			}
		while(rs.next());
		
		order.setOrderItems(items);
		return order;
	};
	
}
