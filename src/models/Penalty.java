package models;

import java.time.LocalDate;

public class Penalty {
    private int id;
    private String studentName, studentNumber, bookName, reason;
    private double amount;
    private LocalDate dateRecorded;
    private boolean settled;

    public Penalty() {
    }

    public Penalty(String studentName, String studentNumber, String bookName, String reason, double amount) {
        this.studentName = studentName;
        this.studentNumber = studentNumber;
        this.bookName = bookName;
        this.reason = reason;
        this.amount = amount;
        this.dateRecorded = LocalDate.now();
        this.settled = false;
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

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public LocalDate getDateRecorded() {
        return dateRecorded;
    }

    public void setDateRecorded(LocalDate dateRecorded) {
        this.dateRecorded = dateRecorded;
    }

    public boolean isSettled() {
        return settled;
    }

    public void setSettled(boolean settled) {
        this.settled = settled;
    }
}