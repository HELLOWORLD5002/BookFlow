package dao;

import models.Penalty;
import util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PenaltyDAO {

    public List<Penalty> getAll() {
        List<Penalty> list = new ArrayList<>();
        String sql = "SELECT * FROM penalties ORDER BY date_recorded DESC";
        try (Connection c = DBConnection.getConnection(); Statement st = c.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Penalty> getByStudent(String studentNumber) {
        List<Penalty> list = new ArrayList<>();
        String sql = "SELECT * FROM penalties WHERE student_number = ? ORDER BY date_recorded DESC";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Penalty p) {
        String sql = "INSERT INTO penalties (student_name, student_number, book_name, reason, amount, date_recorded, settled) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getStudentName());
            ps.setString(2, p.getStudentNumber());
            ps.setString(3, p.getBookName());
            ps.setString(4, p.getReason());
            ps.setDouble(5, p.getAmount());
            ps.setDate(6, Date.valueOf(p.getDateRecorded()));
            ps.setBoolean(7, p.isSettled());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean settle(int id) {
        String sql = "UPDATE penalties SET settled = 1 WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Penalty mapRow(ResultSet rs) throws SQLException {
        Penalty p = new Penalty();
        p.setId(rs.getInt("id"));
        p.setStudentName(rs.getString("student_name"));
        p.setStudentNumber(rs.getString("student_number"));
        p.setBookName(rs.getString("book_name"));
        p.setReason(rs.getString("reason"));
        p.setAmount(rs.getDouble("amount"));
        p.setDateRecorded(rs.getDate("date_recorded").toLocalDate());
        p.setSettled(rs.getBoolean("settled"));
        return p;
    }
}