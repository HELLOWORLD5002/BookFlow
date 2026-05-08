package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;


public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
}


