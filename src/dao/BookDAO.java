package dao;

import models.Book;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    public List<Book> getAll() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY category, title";
        try (Connection c = DBConnection.getConnection(); Statement st = c.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Book getById(int id) { String sql2 = "SELECT * FROM books WHERE id = ?"; try (Connection c2 = DBConnection.getConnection(); PreparedStatement ps2 = c2.prepareStatement(sql2)) { ps2.setInt(1, id); ResultSet rs2 = ps2.executeQuery(); if (rs2.next()) return mapRow(rs2); } catch (SQLException e) { e.printStackTrace(); } return null; } public Book getByBookNo(String bookNo) {
        String sql = "SELECT * FROM books WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, bookNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStock(String bookNo, int newStock) {
        String sql = "UPDATE books SET stock = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setString(2, bookNo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insert(Book b) {
        String sql = "INSERT INTO books (book_no, name, author, category, stock, damaged, price) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, b.getBookNo());
            ps.setString(2, b.getName());
            ps.setString(3, b.getAuthor());
            ps.setString(4, b.getCategory());
            ps.setInt(5, b.getStock());
            ps.setBoolean(6, b.isDamaged());
            ps.setDouble(7, b.getPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteById(int id) { String sql = "DELETE FROM books WHERE id = ?"; try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) { ps.setInt(1, id); return ps.executeUpdate() > 0; } catch (SQLException e) { e.printStackTrace(); } return false; } private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setBookNo(rs.getString("isbn"));
        b.setName(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setStock(rs.getInt("copies"));
        b.setDamaged(!"AVAILABLE".equals(rs.getString("status")));
        b.setPrice(0.0);
        return b;
    }
}
