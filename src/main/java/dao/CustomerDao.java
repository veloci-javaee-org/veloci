package dao;

import java.sql.Connection;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import models.Customer;

public interface CustomerDao {

    /**
     * Inserts a customer row using the given connection, so it can participate
     * in the same transaction as the preceding users insert.
     * Expects customer.getUserId() to already be set to the generated users.id.
     */
    void insert(Connection conn, Customer customer) throws SQLException;

    boolean existsByEmail(String email) throws SQLException;

    boolean existsByPhone(String phone) throws SQLException;
    
    List<Customer> findAll(Connection conn) throws SQLException;
    
    Optional<Customer> findById(Connection conn, int id) throws SQLException;
}