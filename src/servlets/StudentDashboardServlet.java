package servlets;

import dao.*;
import models.Student;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;


public class StudentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentNumber = (String) request.getSession().getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        TransactionDAO txDAO = new TransactionDAO();
        PenaltyDAO penaltyDAO = new PenaltyDAO();
        BookDAO bookDAO = new BookDAO();
        StudentDAO studentDAO = new StudentDAO();

        Student current = studentDAO.getByStudentNumber(studentNumber);

        request.setAttribute("currentStudent", current);
        request.setAttribute("myTransactions", txDAO.getByStudent(studentNumber));
        request.setAttribute("myPenalties", penaltyDAO.getByStudent(studentNumber));
        request.setAttribute("allBooks", bookDAO.getAll());

        request.getRequestDispatcher("/pages/student_dashboard.jsp").forward(request, response);
    }
}


