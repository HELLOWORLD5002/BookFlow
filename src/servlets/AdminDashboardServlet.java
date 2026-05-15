package servlets;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminName = (String) request.getSession().getAttribute("adminName");
        if (adminName == null) { response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); return; }
        TransactionDAO txDAO = new TransactionDAO();
        BookDAO bookDAO = new BookDAO();
        StudentDAO studentDAO = new StudentDAO();
        PenaltyDAO penaltyDAO = new PenaltyDAO();
        List books2 = bookDAO.getAll();
        List students2 = studentDAO.getAll();
        List tx2 = txDAO.getAll();
        request.setAttribute("transactions", tx2);
        request.setAttribute("books", books2);
        request.setAttribute("students", students2);
        request.setAttribute("penalties", penaltyDAO.getAll());
        request.setAttribute("totalBooks", (int)books2.size());
        int avail = 0;
        for (Object o : books2) { models.Book b = (models.Book)o; if (!b.isDamaged() && b.getStock() > 0) avail++; }
        request.setAttribute("availableBooks", avail);
        request.setAttribute("totalStudents", (int)students2.size());
        int overdue = 0;
        for (Object o : tx2) { models.Transaction t = (models.Transaction)o; if (!t.isReturned() && t.getExpectedReturn() != null && t.getExpectedReturn().isBefore(java.time.LocalDate.now())) overdue++; }
        request.setAttribute("overdueCount", overdue);
        double unpaid = penaltyDAO.getAll().stream().filter(p -> !((models.Penalty)p).isSettled()).mapToDouble(p -> ((models.Penalty)p).getAmount()).sum(); request.setAttribute("unpaidTotal", unpaid);
        request.getRequestDispatcher("/pages/admin_dashboard.jsp").forward(request, response);
    }
}
