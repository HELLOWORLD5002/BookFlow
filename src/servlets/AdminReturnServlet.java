package servlets;
import dao.*;
import models.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
public class AdminReturnServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminName = (String) request.getSession().getAttribute("adminName");
        if (adminName == null) { response.sendRedirect(request.getContextPath() + "/pages/login.jsp"); return; }
        int transactionId = Integer.parseInt(request.getParameter("transactionId"));
        String type = request.getParameter("type");
        TransactionDAO txDAO = new TransactionDAO();
        PenaltyDAO penaltyDAO = new PenaltyDAO();
        Transaction t = txDAO.getById(transactionId);
        if (t != null && !t.isReturned()) {
            txDAO.markReturned(transactionId);
            double fine = 0;
            String reason = "";
            if (type.equals("damaged")) { fine = 200.0; reason = "Damaged Book"; }
            else if (type.equals("lost")) { fine = 500.0; reason = "Lost Book"; }
            else { fine = t.computeOverdueFine(); reason = "Overdue Fine"; }
            if (fine > 0) {
                Penalty p = new Penalty(t.getStudentName(), t.getStudentNumber(), t.getBookName(), reason, fine);
                penaltyDAO.insert(p);
            }
            try {
                BookDAO bookDAO = new BookDAO();
                int bid = Integer.parseInt(t.getBookNo());
                Book book = bookDAO.getById(bid);
                if (book != null && !type.equals("lost")) bookDAO.updateStock(t.getBookNo(), book.getStock() + 1);
            } catch(Exception ex) {}
        }
        response.sendRedirect(request.getContextPath() + "/admin");
    }
}
