package models;

public class Book {
    private int id;
    private String bookNo, name, author, category;
    private int stock;
    private boolean damaged;
    private double price;

    public Book() {}

    public String getStatus() {
        if (damaged) return "Damaged";
        return stock > 0 ? "Available" : "Not Available";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getBookNo() { return bookNo; }
    public void setBookNo(String bookNo) { this.bookNo = bookNo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public boolean isDamaged() { return damaged; }
    public void setDamaged(boolean damaged) { this.damaged = damaged; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}