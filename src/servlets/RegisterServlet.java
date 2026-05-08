package servlets;

import dao.StudentDAO;
import models.Student;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String studentNumber = request.getParameter("studentNumber");
        String email = request.getParameter("email");
        String program = request.getParameter("program");
        String password = request.getParameter("password");

        StudentDAO dao = new StudentDAO();

        if (dao.getByStudentNumber(studentNumber) != null) {
            request.setAttribute("error", "Student number already registered!");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        Student s = new Student(name, studentNumber, email, program, password);
        if (dao.insert(s)) {
            request.setAttribute("success", "Account created! You can now login.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }
}