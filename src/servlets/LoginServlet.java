package servlets;

import dao.StudentDAO;
import models.Student;
import util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;


public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if ("admin".equals(role)) {
            try (Connection c = DBConnection.getConnection();
                    PreparedStatement ps = c.prepareStatement("SELECT * FROM admins WHERE name=? AND password=?")) {
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminName", rs.getString("name"));
                    session.setAttribute("role", "admin");
                    response.sendRedirect(request.getContextPath() + "/admin");
                    return;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            StudentDAO dao = new StudentDAO();
            Student s = dao.getByStudentNumber(username);
            if (s != null && s.getPassword().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("studentName", s.getName());
                session.setAttribute("studentNumber", s.getStudentNumber());
                session.setAttribute("studentId", s.getId());
                session.setAttribute("role", "student");
                response.sendRedirect(request.getContextPath() + "/student");
                return;
            }
        }

        request.setAttribute("error", "Invalid username or password.");
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
}


