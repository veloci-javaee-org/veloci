package servlet;

import java.io.IOException;

import dto.SignupRequestDto;
import enums.RoleEnum;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;

@WebServlet("/signup")
public class Signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/signup.html").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SignupRequestDto dto = new SignupRequestDto(
                request.getParameter("name"),
                request.getParameter("username"),
                request.getParameter("email"),
                request.getParameter("password"),
                request.getParameter("phone"),
                request.getParameter("address")
        );

        String error = userService.signup(dto);

        if (error == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.html");
        	
        } else {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/views/signup.html").forward(request, response);
        }
    }
}