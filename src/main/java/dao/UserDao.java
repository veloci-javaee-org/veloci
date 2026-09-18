package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;

import models.AuthenticatedUser;
import models.User;

public interface UserDao {

    /**
     * Inserts a user row using the given connection (so callers can control
     * the transaction boundary, e.g. when a customer signup needs both
     * a users insert and a customers insert to succeed or fail together).
     * Returns the generated id.
     */
    int insert(Connection conn, User user) throws SQLException;

    boolean existsByUsername(String username) throws SQLException;

    /**
     * Looks up everything needed to authenticate and populate a session,
     * matching by EITHER username (works for admins, who have no customers row)
     * OR email (works for customers). username/password/role live on users;
     * name/email live on customers, so a LEFT JOIN is used since admins have no
     * matching customers row at all.
     */
    Optional<AuthenticatedUser> findAuthenticatedUserByIdentifier(String identifier) throws SQLException;
}