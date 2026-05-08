package servlets;

import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;


public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String adminName = (String) request.getSession().getAttribute("adminName");
        if (adminName == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        TransactionDAO txDAO = new TransactionDAO();
        BookDAO bookDAO = new BookDAO();
        StudentDAO studentDAO = new StudentDAO();
        PenaltyDAO penaltyDAO = new PenaltyDAO();

        request.setAttribute("transactions", txDAO.getAll());
        request.setAttribute("books", bookDAO.getAll());
        request.setAttribute("students", studentDAO.getAll());
        request.setAttribute("penalties", penaltyDAO.getAll());

        request.getRequestDispatcher("/pages/admin_dashboard.jsp").forward(request, response);
    }
}


