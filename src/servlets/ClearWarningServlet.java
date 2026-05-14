package servlets;
import dao.StudentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
public class ClearWarningServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminName = (String) request.getSession().getAttribute("adminName");
        if (adminName == null) { response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); return; }
        String studentNumber = request.getParameter("studentNumber");
        new StudentDAO().updateWarningCount(studentNumber, 0);
        response.sendRedirect(request.getContextPath() + "/admin");
    }
}
