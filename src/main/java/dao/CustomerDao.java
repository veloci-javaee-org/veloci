package dao;

import java.sql.Connection;

import java.sql.SQLException;

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
}