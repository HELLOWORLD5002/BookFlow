package servlets;

import dao.*;
import models.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;


public class ReturnServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentNumber = (String) request.getSession().getAttribute("studentNumber");
        if (studentNumber == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int transactionId = Integer.parseInt(request.getParameter("transactionId"));
        TransactionDAO txDAO = new TransactionDAO();
        BookDAO bookDAO = new BookDAO();
        PenaltyDAO penaltyDAO = new PenaltyDAO();

        Transaction t = txDAO.getById(transactionId);
        if (t != null && !t.isReturned()) {
            txDAO.markReturned(transactionId);
            Book book = bookDAO.getByBookNo(t.getBookNo());
            if (book != null)
                bookDAO.updateStock(t.getBookNo(), book.getStock() + 1);

            double fine = t.computeOverdueFine();
            if (fine > 0) {
                Penalty p = new Penalty(
                        t.getStudentName(), t.getStudentNumber(),
                        t.getBookName(), "Overdue Fine", fine);
                penaltyDAO.insert(p);
            }
        }

        response.sendRedirect(request.getContextPath() + "/student");
    }
}


