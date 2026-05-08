package servlets;

import dao.*;
import models.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;


public class BorrowServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentNumber = (String) request.getSession().getAttribute("studentNumber");
        String studentName = (String) request.getSession().getAttribute("studentName");
        if (studentNumber == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String bookNo = request.getParameter("bookNo");
        TransactionDAO txDAO = new TransactionDAO();
        BookDAO bookDAO = new BookDAO();

        long activeCount = txDAO.getActiveByStudent(studentNumber).size();
        if (activeCount >= 3) {
            response.sendRedirect(request.getContextPath() + "/student?error=maxbooks");
            return;
        }

        if (txDAO.hasActiveBorrow(studentNumber, bookNo)) {
            response.sendRedirect(request.getContextPath() + "/student?error=duplicate");
            return;
        }

        Book book = bookDAO.getByBookNo(bookNo);
        if (book == null || book.getStock() <= 0) {
            response.sendRedirect(request.getContextPath() + "/student?error=unavailable");
            return;
        }

        Transaction t = new Transaction();
        t.setStudentName(studentName);
        t.setStudentNumber(studentNumber);
        t.setBookNo(book.getBookNo());
        t.setBookName(book.getName());
        t.setAuthor(book.getAuthor());
        t.setBorrowDate(LocalDate.now());
        t.setExpectedReturn(LocalDate.now().plusDays(7));
        t.setReturned(false);

        txDAO.insert(t);
        bookDAO.updateStock(bookNo, book.getStock() - 1);

        response.sendRedirect(request.getContextPath() + "/student");
    }
}


