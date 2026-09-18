package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static String url;
    private static String user;
    private static String password;
    private static boolean initialized = false;

    private DBConnection() {
        // static utility class, no instances
    }

    /**
     * Called once by AppContextListener at application startup,
     * with values read from web.xml context-params.
     */
    public static synchronized void init(String url, String user, String password) {
        DBConnection.url = url;
        DBConnection.user = user;
        DBConnection.password = password;

        // Explicitly force-load the driver class rather than relying solely on
        // JDBC 4's automatic ServiceLoader discovery, which can occasionally
        // fail to trigger depending on the servlet container's classloader setup.
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException(
                "MySQL JDBC driver class not found on classpath. Check that mysql-connector-j's jar is in WEB-INF/lib.", e);
        }

        DBConnection.initialized = true;
    }

    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            throw new IllegalStateException(
                "DBConnection was not initialized. Check that AppContextListener ran and web.xml has db.url/db.user/db.password context-params.");
        }
        return DriverManager.getConnection(url, user, password);
    }
}