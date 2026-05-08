package models;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Transaction {
    private int id;
    private String studentName, studentNumber, bookNo, bookName, author;
    private LocalDate borrowDate, expectedReturn, returnedDate;
    private boolean returned;

    public Transaction() {
    }

    public long daysOverdue() {
        if (returned)
            return -999;
        return ChronoUnit.DAYS.between(expectedReturn, LocalDate.now());
    }

    public double computeOverdueFine() {
        long days = daysOverdue();
        if (days <= 0)
            return 0;
        if (days <= 14)
            return days * 5.0;
        if (days <= 30)
            return (14 * 5.0) + ((days - 14) * 10.0);
        return (14 * 5.0) + (16 * 10.0);
    }

    public String getStatusLabel() {
        if (returned)
            return "Returned";
        long d = daysOverdue();
        if (d > 30)
            return "CRITICAL";
        if (d > 14)
            return "3rd Warning";
        if (d > 7)
            return "2nd Warning";
        if (d > 0)
            return "1st Warning";
        if (d == 0)
            return "Due Today!";
        if (d >= -1)
            return "Due Tomorrow";
        if (d >= -3)
            return "Due Soon";
        return "Active";
    }

    public String getRowColor() {
        if (returned)
            return "#EBEBEB";
        long d = daysOverdue();
        if (d > 0)
            return "#FFD2D2";
        if (d == 0)
            return "#FFE1BE";
        if (d >= -3)
            return "#FFFDC8";
        return "#DCFFE1";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentNumber() {
        return studentNumber;
    }

    public void setStudentNumber(String studentNumber) {
        this.studentNumber = studentNumber;
    }

    public String getBookNo() {
        return bookNo;
    }

    public void setBookNo(String bookNo) {
        this.bookNo = bookNo;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public LocalDate getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(LocalDate borrowDate) {
        this.borrowDate = borrowDate;
    }

    public LocalDate getExpectedReturn() {
        return expectedReturn;
    }

    public void setExpectedReturn(LocalDate expectedReturn) {
        this.expectedReturn = expectedReturn;
    }

    public LocalDate getReturnedDate() {
        return returnedDate;
    }

    public void setReturnedDate(LocalDate returnedDate) {
        this.returnedDate = returnedDate;
    }

    public boolean isReturned() {
        return returned;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }
}