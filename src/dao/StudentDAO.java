package dao;

import models.Student;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public Student getByStudentNumber(String studentNumber) {
        String sql = "SELECT * FROM students WHERE student_number = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, studentNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Student getById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
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

    public List<Student> getAll() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY full_name";
        try (Connection c = DBConnection.getConnection(); Statement st = c.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Student s) {
        String sql = "INSERT INTO students (full_name, student_number, email, program, password, warning_level) VALUES (?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getStudentNumber());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getProgram());
            ps.setString(5, s.getPassword());
            ps.setInt(6, s.getWarningCount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateWarningCount(String studentNumber, int count) {
        String sql = "UPDATE students SET warning_level = ? WHERE student_number = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, count);
            ps.setString(2, studentNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("full_name"));
        s.setStudentNumber(rs.getString("student_number"));
        s.setEmail(rs.getString("email"));
        s.setProgram(rs.getString("program"));
        s.setPassword(rs.getString("password"));
        s.setWarningCount(rs.getInt("warning_level")); s.setAccountStatus(rs.getString("account_status") != null ? rs.getString("account_status") : "ACTIVE");
        return s;
    }

    public void deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id); ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateStudentStatus(int id, String status) {
        String sql = "UPDATE students SET account_status = ? WHERE id = ?";
        try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, id); ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}