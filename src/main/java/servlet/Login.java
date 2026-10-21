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
		HttpSession session = request.getSession(false);
		if (session != null && session.getAttribute("username") != null) {
			Object role = session.getAttribute("role");
			if (RoleEnum.ADMIN.equals(role)) {
				response.sendRedirect(request.getContextPath() + "/admin");
			} else {
				response.sendRedirect(request.getContextPath() + "/products");
			}
			return;
		}
		request.getRequestDispatcher("/views/login.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		LoginRequestDto dto = new LoginRequestDto(request.getParameter("identifier"), request.getParameter("password"));

		LoginResult result = userService.login(dto);

		if (result.isSuccess()) {
			AuthenticatedUser user = result.getUser();

			HttpSession previousSession = request.getSession(false);
			if (previousSession != null) {
				previousSession.invalidate();
			}
			HttpSession session = request.getSession(true);
			session.setAttribute("username", user.getUsername());
			session.setAttribute("name", user.getName());
			session.setAttribute("email", user.getEmail());
			session.setAttribute("role", user.getRole());
			session.setMaxInactiveInterval(30 * 60);

			if (RoleEnum.ADMIN.equals(user.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin");
			} else {
				response.sendRedirect(request.getContextPath() + "/products");
			}

		} else {
			String msg = URLEncoder.encode(result.getError(), StandardCharsets.UTF_8);
			response.sendRedirect(request.getContextPath() + "/login?error=" + msg);
		}
	}
}