package service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;

import dao.CustomerDao;
import dao.CustomerDaoImpl;
import dao.UserDao;
import dao.UserDaoImpl;
import database.DBConnection;
import dto.LoginRequestDto;
import dto.SignupRequestDto;
import mapper.CustomerMapper;
import models.AuthenticatedUser;
import models.Customer;
import util.PasswordHasher;

public class UserService {

    private final UserDao userDao;
    private final CustomerDao customerDao;

    // Default constructor wires the real JDBC implementations.
    public UserService() {
        this(new UserDaoImpl(), new CustomerDaoImpl());
    }

    // Constructor injection: lets tests substitute fake/mock DAOs without touching a real DB.
    public UserService(UserDao userDao, CustomerDao customerDao) {
        this.userDao = userDao;
        this.customerDao = customerDao;
    }

    // ---------------------------------------------------------------
    // LOGIN
    // ---------------------------------------------------------------
    public LoginResult login(LoginRequestDto dto) {
        String validationError = validateLogin(dto);
        if (validationError != null) {
            return LoginResult.failure(validationError);
        }

        try {
            Optional<AuthenticatedUser> found = userDao.findAuthenticatedUserByIdentifier(dto.getIdentifier());

            if (found.isPresent() && PasswordHasher.matches(dto.getPassword(), found.get().getPasswordHash())) {
                return LoginResult.success(found.get());
            }
            return LoginResult.failure("Invalid username/email or password.");

        } catch (SQLException e) {
            e.printStackTrace();
            return LoginResult.failure("Database error occurred.");
        }
    }

    private String validateLogin(LoginRequestDto dto) {
        // No email-format check here on purpose: the identifier can legitimately
        // be a plain username (admins have no email at all), so we only check
        // that something was entered, not that it looks like an email address.
        if (dto.getIdentifier() == null || dto.getIdentifier().trim().isEmpty()) {
            return "Username or email is required.";
        }
        if (dto.getPassword() == null || dto.getPassword().isEmpty()) {
            return "Password is required.";
        }
        return null;
    }

    // ---------------------------------------------------------------
    // SIGNUP
    // ---------------------------------------------------------------
    public String signup(SignupRequestDto dto) {
        String validationError = validateSignup(dto);
        if (validationError != null) {
            return validationError;
        }

        try {
            if (userDao.existsByUsername(dto.getUsername())) {
                return "Username already taken.";
            }
            if (customerDao.existsByEmail(dto.getEmail())) {
                return "This email already exists.";
            }
            if (customerDao.existsByPhone(dto.getPhone())) {
                return "Phone number already exists.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Database error occurred.";
        }

        Customer customer = CustomerMapper.toEntity(dto);
        customer.setPassword(PasswordHasher.hash(customer.getPassword()));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // start transaction spanning both inserts

            int generatedUserId = userDao.insert(conn, customer.getUser());
            customer.setUserId(generatedUserId);

            customerDao.insert(conn, customer);

            conn.commit();
            return null; // success

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return "Database error occurred.";
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    private String validateSignup(SignupRequestDto dto) {
        if (dto.getName() == null || dto.getName().trim().isEmpty()) {
            return "Name is required.";
        }
        if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
            return "Username is required.";
        }
        if (dto.getEmail() == null || dto.getEmail().trim().isEmpty()) {
            return "Email is required.";
        }
        if (!dto.getEmail().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return "Invalid email format.";
        }
        if (dto.getPhone() == null || dto.getPhone().trim().isEmpty()) {
            return "Phone number is required.";
        }
        if (!dto.getPhone().matches("\\d{10,15}")) {
            return "Phone number must be 10-15 digits.";
        }
        if (dto.getPassword() == null || dto.getPassword().isEmpty()) {
            return "Password is required.";
        }
        if (dto.getPassword().length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        return null;
    }
}