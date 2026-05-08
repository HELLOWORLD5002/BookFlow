package dao;

import models.Book;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    public List<Book> getAll() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY category, name";
        try (Connection c = DBConnection.getConnection(); Statement st = c.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Book getByBookNo(String bookNo) {
        String sql = "SELECT * FROM books WHERE book_no = ?";
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
        String sql = "UPDATE books SET stock = ? WHERE book_no = ?";
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

    private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setBookNo(rs.getString("book_no"));
        b.setName(rs.getString("name"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setStock(rs.getInt("stock"));
        b.setDamaged(rs.getBoolean("damaged"));
        b.setPrice(rs.getDouble("price"));
        return b;
    }
}