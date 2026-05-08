package dao;

import models.Transaction;
import util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public List<Transaction> getAll() {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions ORDER BY borrow_date DESC";
        try (Connection c = DBConnection.getConnection(); Statement st = c.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getByStudent(String studentNumber) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE student_number = ? ORDER BY borrow_date DESC";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getActiveByStudent(String studentNumber) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE student_number = ? AND returned = 0";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getOverdueByStudent(String studentNumber) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE student_number = ? AND returned = 0 AND expected_return < CURDATE()";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Transaction getById(int id) {
        String sql = "SELECT * FROM transactions WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Transaction t) {
        String sql = "INSERT INTO transactions (student_name, student_number, book_no, book_name, author, borrow_date, expected_return, returned) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, t.getStudentName());
            ps.setString(2, t.getStudentNumber());
            ps.setString(3, t.getBookNo());
            ps.setString(4, t.getBookName());
            ps.setString(5, t.getAuthor());
            ps.setDate(6, Date.valueOf(t.getBorrowDate()));
            ps.setDate(7, Date.valueOf(t.getExpectedReturn()));
            ps.setBoolean(8, false);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markReturned(int id) {
        String sql = "UPDATE transactions SET returned = 1, returned_date = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(LocalDate.now()));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasActiveBorrow(String studentNumber, String bookNo) {
        String sql = "SELECT id FROM transactions WHERE student_number = ? AND book_no = ? AND returned = 0";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ps.setString(2, bookNo);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Transaction mapRow(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setId(rs.getInt("id"));
        t.setStudentName(rs.getString("student_name"));
        t.setStudentNumber(rs.getString("student_number"));
        t.setBookNo(rs.getString("book_no"));
        t.setBookName(rs.getString("book_name"));
        t.setAuthor(rs.getString("author"));
        t.setBorrowDate(rs.getDate("borrow_date").toLocalDate());
        t.setExpectedReturn(rs.getDate("expected_return").toLocalDate());
        Date ret = rs.getDate("returned_date");
        if (ret != null)
            t.setReturnedDate(ret.toLocalDate());
        t.setReturned(rs.getBoolean("returned"));
        return t;
    }
}