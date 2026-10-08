package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import dto.LoginRequestDto;
import enums.RoleEnum;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.AuthenticatedUser;
import service.LoginResult;
import service.UserService;

@WebServlet("/login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login.html").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LoginRequestDto dto = new LoginRequestDto(
                request.getParameter("identifier"),
                request.getParameter("password")
        );

        LoginResult result = userService.login(dto);

        if (result.isSuccess()) {
            AuthenticatedUser user = result.getUser();

            HttpSession session = request.getSession(true);
            
            // These data of AuthenticatedUser will be used through the app to authorized the us
            session.setAttribute("username", user.getUsername());
            session.setAttribute("name", user.getName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60);
            
            
            if (RoleEnum.ADMIN.equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/views/admin_panel.html");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }

        } else {
            String msg = URLEncoder.encode(result.getError(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/views/login.html?error=" + msg);
        }
    }
}