<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, models.*, java.time.LocalDate" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<models.Transaction> transactions = (List<models.Transaction>) request.getAttribute("transactions");
    List<models.Book> books = (List<models.Book>) request.getAttribute("books");
    List<models.Student> students = (List<models.Student>) request.getAttribute("students");
    List<models.Penalty> penalties = (List<models.Penalty>) request.getAttribute("penalties");
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    Integer availableBooks = (Integer) request.getAttribute("availableBooks");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer overdueCount = (Integer) request.getAttribute("overdueCount");
    Double unpaidTotal = (Double) request.getAttribute("unpaidTotal");
    if (totalBooks == null) totalBooks = 0;
    if (availableBooks == null) availableBooks = 0;
    if (totalStudents == null) totalStudents = 0;
    if (overdueCount == null) overdueCount = 0;
    if (unpaidTotal == null) unpaidTotal = 0.0;
    if (transactions == null) transactions = new java.util.ArrayList<>();
    if (books == null) books = new java.util.ArrayList<>();
    if (students == null) students = new java.util.ArrayList<>();
    if (penalties == null) penalties = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BookFlow Admin</title>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
:root{--navy:#122146;--sidebar:#0c1837;--green:#2E7D32;--sidebar-w:220px;}
body{font-family:'Segoe UI',sans-serif;background:#f4f6f8;display:flex;min-height:100vh;}
.sidebar{width:var(--sidebar-w);background:var(--sidebar);color:white;display:flex;flex-direction:column;position:fixed;height:100vh;}
.sidebar-brand{padding:24px 20px 16px;border-bottom:1px solid rgba(255,255,255,0.1);}
.sidebar-brand h1{font-size:22px;color:#4CAF50;font-weight:700;}
.sidebar-brand p{font-size:11px;color:#aaa;margin-top:2px;}
.sidebar-user{padding:16px 20px;border-bottom:1px solid rgba(255,255,255,0.1);}
.sidebar-user .role{font-size:10px;color:#aaa;text-transform:uppercase;}
.sidebar-user .name{font-size:14px;font-weight:600;color:white;}
.sidebar-nav{flex:1;padding:16px 0;}
.nav-item{display:block;padding:12px 20px;color:#ccc;text-decoration:none;cursor:pointer;font-size:14px;border:none;background:none;width:100%;text-align:left;}
.nav-item:hover,.nav-item.active{background:rgba(76,175,80,0.2);color:white;border-left:3px solid #4CAF50;}
.sidebar-logout{padding:16px 20px;border-top:1px solid rgba(255,255,255,0.1);}
.sidebar-logout a{color:#ef9a9a;text-decoration:none;font-size:14px;}
.main{margin-left:var(--sidebar-w);flex:1;display:flex;flex-direction:column;}
.topbar{background:white;padding:16px 28px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid #e0e0e0;position:sticky;top:0;z-index:10;}
.topbar h2{font-size:18px;color:var(--navy);}
.topbar .brand{font-size:14px;color:#888;}
.content{padding:24px 28px;}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:24px;}
.stat-card{background:white;border-radius:8px;padding:20px;border-left:4px solid #ccc;}
.stat-card.green{border-color:#4CAF50;}.stat-card.blue{border-color:#1976D2;}.stat-card.red{border-color:#e53935;}.stat-card.orange{border-color:#FB8C00;}
.stat-label{font-size:11px;color:#888;text-transform:uppercase;margin-bottom:6px;}
.stat-value{font-size:28px;font-weight:700;color:var(--navy);}
.stat-sub{font-size:12px;color:#aaa;margin-top:4px;}
.tabs{display:flex;gap:8px;margin-bottom:20px;}
.tab-btn{padding:8px 18px;border:none;border-radius:6px;cursor:pointer;font-size:13px;background:#e0e0e0;color:#555;}
.tab-btn.active{background:var(--navy);color:white;}
.panel{display:none;background:white;border-radius:8px;padding:20px;}
.panel.active{display:block;}
.panel-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;}
.panel-header h3{font-size:16px;color:var(--navy);}
table{width:100%;border-collapse:collapse;font-size:13px;}
th{text-align:left;padding:10px 12px;background:#f5f5f5;color:#555;font-weight:600;text-transform:uppercase;font-size:11px;}
td{padding:10px 12px;border-bottom:1px solid #f0f0f0;color:#333;}
tr.row-red td{background:#fff8f8;}
tr.row-gray td{background:#f9f9f9;color:#aaa;}
.badge{padding:3px 10px;border-radius:12px;font-size:11px;font-weight:600;}
.badge-green{background:#e8f5e9;color:#2E7D32;}.badge-red{background:#ffebee;color:#c62828;}
.badge-orange{background:#fff3e0;color:#e65100;}.badge-navy{background:#e8eaf6;color:#1a237e;}
.btn{padding:5px 12px;border:none;border-radius:4px;cursor:pointer;font-size:12px;font-weight:600;}
.btn-green{background:#2E7D32;color:white;}.btn-red{background:#c62828;color:white;}
.btn-orange{background:#e65100;color:white;}.btn-blue{background:#1565C0;color:white;}
.add-form{background:#f9f9f9;border-radius:8px;padding:16px;margin-bottom:20px;display:none;}
.add-form.open{display:block;}
.form-row{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:12px;}
.form-row input,.form-row select{padding:8px 10px;border:1px solid #ddd;border-radius:4px;font-size:13px;width:100%;}
.empty-msg{color:#aaa;text-align:center;padding:40px;font-size:14px;}
</style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-brand"><h1>BookFlow</h1><p>RTU Library System</p></div>
  <div class="sidebar-user">
    <div class="role">Admin Panel</div>
    <div class="name"><%= adminName %></div>
  </div>
  <nav class="sidebar-nav">
    <a class="nav-item active" onclick="showTab('transactions')">&#128203; Transactions</a>
    <a class="nav-item" onclick="showTab('books')">&#128218; Books</a>
    <a class="nav-item" onclick="showTab('students')">&#128101; Students</a>
    <a class="nav-item" onclick="showTab('penalties')">&#128176; Penalties</a>
  </nav>
  <div class="sidebar-logout"><a href="<%= request.getContextPath() %>/logout">&#128682; Logout</a></div>
</aside>
<div class="main">
  <div class="topbar">
    <h2 id="topbar-title">All Transactions</h2>
    <span class="brand">BookFlow Admin Dashboard</span>
  </div>
  <div class="content">
    <div class="stats">
      <div class="stat-card green"><div class="stat-label">Total Books</div><div class="stat-value"><%= totalBooks %></div><div class="stat-sub"><%= availableBooks %> available</div></div>
      <div class="stat-card blue"><div class="stat-label">Students</div><div class="stat-value"><%= totalStudents %></div><div class="stat-sub">registered accounts</div></div>
      <div class="stat-card red"><div class="stat-label">Overdue</div><div class="stat-value"><%= overdueCount %></div><div class="stat-sub">active overdue books</div></div>
      <div class="stat-card orange"><div class="stat-label">Unpaid Fines</div><div class="stat-value">&#8369;<%= String.format("%.0f", unpaidTotal) %></div><div class="stat-sub">total outstanding</div></div>
    </div>
    <div class="tabs">
      <button class="tab-btn active" onclick="showTab('transactions')">&#128203; Transactions</button>
      <button class="tab-btn" onclick="showTab('books')">&#128218; Books</button>
      <button class="tab-btn" onclick="showTab('students')">&#128101; Students</button>
      <button class="tab-btn" onclick="showTab('penalties')">&#128176; Penalties</button>
    </div>
    <div id="panel-transactions" class="panel active">
      <div class="panel-header"><h3>All Transactions</h3></div>
      <% if (transactions.isEmpty()) { %><div class="empty-msg">No transactions yet.</div><% } else { %>
      <table><thead><tr><th>Student</th><th>Book</th><th>Borrowed</th><th>Due Date</th><th>Status</th><th>Action</th></tr></thead><tbody>
      <% for (models.Transaction t : transactions) { String tClass = "OVERDUE".equals(t.getStatus()) ? "row-red" : ("RETURNED".equals(t.getStatus()) ? "row-gray" : ""); %>
      <tr class="<%= tClass %>">
        <td><strong><%= t.getStudentName() %></strong><br><small><%= t.getStudentNumber() %></small></td>
        <td><%= t.getBookName() %></td>
        <td><%= t.getBorrowDate() %></td>
        <td><%= t.getDueDate() %></td>
        <td><span class="badge <%= "OVERDUE".equals(t.getStatus()) ? "badge-red" : ("RETURNED".equals(t.getStatus()) ? "badge-navy" : "badge-green") %>"><%= t.getStatus() %></span></td>
        <td>
        <% if (!"RETURNED".equals(t.getStatus())) { %>
          <form action="<%= request.getContextPath() %>/adminreturn" method="POST" style="display:inline;"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><button type="submit" class="btn btn-blue">Return</button></form>
          <form action="<%= request.getContextPath() %>/adminreturn" method="POST" style="display:inline;"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><input type="hidden" name="damaged" value="true"><button type="submit" class="btn btn-orange">Damaged</button></form>
          <form action="<%= request.getContextPath() %>/adminreturn" method="POST" style="display:inline;"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><input type="hidden" name="lost" value="true"><button type="submit" class="btn btn-red">Lost</button></form>
        <% } %>
        </td>
      </tr>
      <% } %></tbody></table><% } %>
    </div>
    <div id="panel-books" class="panel">
      <div class="panel-header"><h3>&#128218; Book Inventory</h3><button class="btn btn-green" onclick="document.getElementById('addBookForm').classList.toggle('open')">+ Add Book</button></div>
      <div id="addBookForm" class="add-form">
        <form action="<%= request.getContextPath() %>/addbook" method="POST">
          <div class="form-row"><input type="text" name="title" placeholder="Book Title" required><input type="text" name="author" placeholder="Author" required><input type="text" name="category" placeholder="Category" required></div>
          <div class="form-row"><input type="number" name="copies" placeholder="Number of Copies" min="1" required></div>
          <button type="submit" class="btn btn-green">Add Book</button>
        </form>
      </div>
      <% if (books.isEmpty()) { %><div class="empty-msg">No books found.</div><% } else { %>
      <table><thead><tr><th>Title</th><th>Author</th><th>Category</th><th>Status</th><th>Copies</th><th>Action</th></tr></thead><tbody>
      <% for (models.Book b : books) { %>
      <tr><td><%= b.getTitle() %></td><td><%= b.getAuthor() %></td><td><%= b.getCategory() %></td><td><span class="badge badge-navy"><%= b.getStatus() %></span></td><td><%= b.getCopies() %></td>
        <td><form action="<%= request.getContextPath() %>/deletebook" method="POST" style="display:inline;"><input type="hidden" name="bookId" value="<%= b.getId() %>"><button type="submit" class="btn btn-red" onclick="return confirm('Delete this book?')">Delete</button></form></td>
      </tr>
      <% } %></tbody></table><% } %>
    </div>
    <div id="panel-students" class="panel">
      <div class="panel-header"><h3>&#128101; Registered Students</h3></div>
      <% if (students.isEmpty()) { %><div class="empty-msg">No students registered.</div><% } else { %>
      <table><thead><tr><th>Name</th><th>Student No.</th><th>Email</th><th>Program</th><th>Warning</th><th>Action</th></tr></thead><tbody>
      <% for (models.Student s : students) { %>
      <tr>
        <td><strong><%= s.getFullName() %></strong></td><td><%= s.getStudentNumber() %></td><td><%= s.getEmail() %></td><td><%= s.getProgram() %></td>
        <td><span class="badge <%= s.getWarningLevel() >= 3 ? "badge-red" : (s.getWarningLevel() > 0 ? "badge-orange" : "badge-green") %>"><% if(s.getWarningLevel()==0){%>None<%}else if(s.getWarningLevel()==1){%>1st Warning<%}else if(s.getWarningLevel()==2){%>2nd Warning<%}else if(s.getWarningLevel()==3){%>3rd Warning<%}else{%>BLOCKED<%}%></span></td>
        <td><% if(s.getWarningLevel()>0){%><form action="<%= request.getContextPath() %>/clearwarning" method="POST" style="display:inline;"><input type="hidden" name="studentId" value="<%= s.getId() %>"><button type="submit" class="btn btn-blue">Clear Warning</button></form><%}%></td>
      </tr>
      <% } %></tbody></table><% } %>
    </div>
    <div id="panel-penalties" class="panel">
      <div class="panel-header"><h3>&#128176; Penalties</h3></div>
      <% if (penalties.isEmpty()) { %><div class="empty-msg">No penalties recorded.</div><% } else { %>
      <table><thead><tr><th>Student</th><th>Book</th><th>Type</th><th>Amount</th><th>Date</th><th>Status</th><th>Action</th></tr></thead><tbody>
      <% for (models.Penalty p : penalties) { %>
      <tr class="<%= p.isSettled() ? "row-gray" : "row-red" %>">
        <td><strong><%= p.getStudentName() %></strong></td><td><%= p.getBookName() %></td>
        <td><span class="badge badge-orange"><%= p.getType() %></span></td>
        <td>&#8369;<%= String.format("%.2f", p.getAmount()) %></td>
        <td><%= p.getDateRecorded() %></td>
        <td><span class="badge <%= p.isSettled() ? "badge-green" : "badge-red" %>"><%= p.isSettled() ? "Paid" : "Unpaid" %></span></td>
        <td><% if(!p.isSettled()){%><form action="<%= request.getContextPath() %>/settle" method="POST" style="display:inline;"><input type="hidden" name="penaltyId" value="<%= p.getId() %>"><button type="submit" class="btn btn-green">Settle</button></form><%}%></td>
      </tr>
      <% } %></tbody></table><% } %>
    </div>
  </div>
</div>
<script>
function showTab(tab) {
    document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
    document.getElementById('panel-' + tab).classList.add('active');
    const titles = {transactions:'All Transactions',books:'Book Inventory',students:'Registered Students',penalties:'Penalties'};
    document.getElementById('topbar-title').textContent = titles[tab];
    document.querySelectorAll('.tab-btn').forEach(b => { if(b.textContent.toLowerCase().includes(tab)) b.classList.add('active'); });
    document.querySelectorAll('.nav-item').forEach(n => { if(n.textContent.toLowerCase().includes(tab)) n.classList.add('active'); });
}
</script>
</body>
</html>