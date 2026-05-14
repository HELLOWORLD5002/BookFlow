package servlets;
import dao.PenaltyDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
public class SettlePenaltyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminName = (String) request.getSession().getAttribute("adminName");
        if (adminName == null) { response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); return; }
        int penaltyId = Integer.parseInt(request.getParameter("penaltyId"));
        new PenaltyDAO().settle(penaltyId);
        response.sendRedirect(request.getContextPath() + "/admin");
    }
}
