package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import database.DBConnection;
import mapper.CustomerMapper;
import models.Customer;
import models.User;

public class CustomerDaoImpl implements CustomerDao {

    @Override
    public void insert(Connection conn, Customer customer) throws SQLException {
        String sql = "INSERT INTO customers (user_id, name, email, phone, address) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customer.getUserId());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPhone());
            ps.setString(5, customer.getAddress());
            ps.executeUpdate();
        }
    }

    @Override
    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public boolean existsByPhone(String phone) throws SQLException {
        String sql = "SELECT 1 FROM customers WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    @Override
    public Optional<Customer> findById(Connection conn, int id) throws SQLException {
    	String sql = """
    			SELECT 
    			c.id 
    			, c.name 
    			, c.email
    			, c.phone
    			, u.registration_date
    			FROM customers c
    			join users u on c.user_id = u.id
    			WHERE c.id = ?
    			""";
    	
    	try(PreparedStatement ps = conn.prepareStatement(sql)) {
    		ps.setInt(1, id);
    		try(ResultSet rs = ps.executeQuery()){
    				if(rs.next())
    				return Optional.ofNullable(CustomerMapper.resultSetToEntity(rs));
    			}
    		}
    		return Optional.empty();

    	}
    
    @Override
    public List<Customer> findAll(Connection conn) throws SQLException {
    	String sql = """
    			SELECT c.id, c.name, c.email, c.phone, u.registration_date
    			FROM customers c
    			join users u on c.user_id = u.id
    			""";
    	List<Customer> customers = new ArrayList<>();
    	try(PreparedStatement ps = conn.prepareStatement(sql);
    			ResultSet rs = ps .executeQuery()) {
    		
    			while(rs.next()) {
    				customers.add(CustomerMapper.resultSetToEntity(rs));
    			
    		}
    	}
    	return customers;
    }
    
    
}