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
        java.util.List books2 = bookDAO.getAll();
        java.util.List students2 = studentDAO.getAll();
        request.setAttribute("totalBooks", books2.size());
        request.setAttribute("availableBooks", books2.stream().filter(b -> !((models.Book)b).isDamaged() && ((models.Book)b).getStock() > 0).count());
        request.setAttribute("totalStudents", students2.size());
        request.setAttribute("overdueCount", txDAO.getAll().stream().filter(t -> !((models.Transaction)t).isReturned() && ((models.Transaction)t).getExpectedReturn().isBefore(java.time.LocalDate.now())).count());
        request.setAttribute("unpaidTotal", 0.0);

        request.getRequestDispatcher("/pages/admin_dashboard.jsp").forward(request, response);
    }
}


