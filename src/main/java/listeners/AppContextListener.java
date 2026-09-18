package listeners;


import database.DBConnection;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        String url = event.getServletContext().getInitParameter("db.url");
        String user = event.getServletContext().getInitParameter("db.user");
        String password = event.getServletContext().getInitParameter("db.password");

        DBConnection.init(url, user, password);
    }
}
