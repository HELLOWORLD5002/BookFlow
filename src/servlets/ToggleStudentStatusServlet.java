package servlets;
import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
public class ToggleStudentStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int studentId = Integer.parseInt(req.getParameter("studentId"));
        String currentStatus = req.getParameter("currentStatus");
        String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";
        new StudentDAO().updateStudentStatus(studentId, newStatus);
        res.sendRedirect(req.getContextPath() + "/admin");
    }
}