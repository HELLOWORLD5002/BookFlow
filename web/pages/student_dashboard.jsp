<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List, models.*" %>
        <% String studentName=(String) session.getAttribute("studentName"); String studentNumber=(String)
            session.getAttribute("studentNumber"); if (studentName==null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp" ); return; } List<models.Transaction>
            myTransactions = (List<models.Transaction>) request.getAttribute("myTransactions");
                List<models.Penalty> myPenalties = (List<models.Penalty>) request.getAttribute("myPenalties");
                        List<models.Book> allBooks = (List<models.Book>) request.getAttribute("allBooks");
                                if (myTransactions == null) myTransactions = new java.util.ArrayList<>();
                                    if (myPenalties == null) myPenalties = new java.util.ArrayList<>();
                                        if (allBooks == null) allBooks = new java.util.ArrayList<>();
                                            long activeCount = myTransactions.stream().filter(t ->
                                            !t.isReturned()).count();
                                            double totalFines = myPenalties.stream().filter(p ->
                                            !p.isSettled()).mapToDouble(models.Penalty::getAmount).sum();
                                            models.Student currentStudent = (models.Student)
                                            request.getAttribute("currentStudent");
                                            %>
                                            <!DOCTYPE html>
                                            <html>

                                            <head>
                                                <meta charset="UTF-8">
                                                <title>BookFlow -- Student Portal</title>
                                                <link rel="stylesheet" href="/BookFlow/css/style.css">
                                            </head>

                                            <body class="dashboard-body">

                                                <div class="sidebar">
                                                    <div class="sidebar-brand">📚 BookFlow</div>
                                                    <div class="sidebar-role">Student Portal</div>
                                                    <nav class="sidebar-nav">
                                                        <a href="#" class="nav-item active"
                                                            onclick="showTab('overview',this)">🏠 Overview</a>
                                                        <a href="#" class="nav-item"
                                                            onclick="showTab('borrowed',this)">📖 My Books</a>
                                                        <a href="#" class="nav-item"
                                                            onclick="showTab('penalties',this)">💰 My Penalties</a>
                                                        <a href="#" class="nav-item" onclick="showTab('browse',this)">🔍
                                                            Browse and Borrow</a>
                                                    </nav>
                                                    <div class="sidebar-bottom">
                                                        <div class="admin-info">👤 <%= studentName %>
                                                        </div>
                                                        <div style="font-size:0.78rem;opacity:0.7;margin-bottom:8px">
                                                            <%= studentNumber %>
                                                        </div>
                                                        <a href="<%= request.getContextPath() %>/logout"
                                                            class="btn-logout">Logout</a>
                                                    </div>
                                                </div>

                                                <div class="main-content">

                                                    <div id="tab-overview" class="tab-content active">
                                                        <h2 style="margin-bottom:4px">Welcome, <%= studentName %>!</h2>
                                                        <p class="student-num">Student No: <%= studentNumber %>
                                                        </p>
                                                        <% if (currentStudent !=null &&
                                                            currentStudent.getWarningCount()> 0) { %>
                                                            <div class="alert alert-warning">
                                                                Warning Level: <strong>
                                                                    <%= currentStudent.getWarningLabel() %>
                                                                </strong>
                                                                <% if (currentStudent.isCriticalBlocked()) { %> -- Your
                                                                    account is BLOCKED. Contact admin.<% } %>
                                                            </div>
                                                            <% } %>
                                                                <div class="stats-row">
                                                                    <div class="stat-card blue">
                                                                        <div class="stat-num">
                                                                            <%= activeCount %> / 3
                                                                        </div>
                                                                        <div class="stat-label">Active Borrows</div>
                                                                    </div>
                                                                    <div class="stat-card orange">
                                                                        <div class="stat-num">
                                                                            <%= myTransactions.stream().filter(t ->
                                                                                !t.isReturned() && t.daysOverdue() >
                                                                                0).count() %>
                                                                        </div>
                                                                        <div class="stat-label">Overdue Books</div>
                                                                    </div>
                                                                    <div class="stat-card red">
                                                                        <div class="stat-num">&#8369;<%=
                                                                                String.format("%.2f", totalFines) %>
                                                                        </div>
                                                                        <div class="stat-label">Total Fines</div>
                                                                    </div>
                                                                    <div class="stat-card green">
                                                                        <div class="stat-num">
                                                                            <%= myTransactions.stream().filter(t ->
                                                                                t.isReturned()).count() %>
                                                                        </div>
                                                                        <div class="stat-label">Books Returned</div>
                                                                    </div>
                                                                </div>
                                                    </div>

                                                    <div id="tab-borrowed" class="tab-content">
                                                        <div class="section-header">
                                                            <h2>📖 My Borrowed Books</h2>
                                                        </div>
                                                        <div class="table-wrap">
                                                            <table class="data-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Book</th>
                                                                        <th>Author</th>
                                                                        <th>Borrow Date</th>
                                                                        <th>Due Date</th>
                                                                        <th>Status</th>
                                                                        <th>Fine</th>
                                                                        <th>Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody id="bookTable">
                                                                    <% boolean hasActive=false; for (models.Transaction
                                                                        t : myTransactions) { if (t.isReturned())
                                                                        continue; hasActive=true; %>
                                                                        <tr
                                                                            style="background-color:<%= t.getRowColor() %>">
                                                                            <td>
                                                                                <%= t.getBookName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= t.getAuthor() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= t.getBorrowDate() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= t.getExpectedReturn() %>
                                                                            </td>
                                                                            <td><span class="status-badge">
                                                                                    <%= t.getStatusLabel() %>
                                                                                </span></td>
                                                                            <td>&#8369;<%= String.format("%.2f",
                                                                                    t.computeOverdueFine()) %>
                                                                            </td>











                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                            <% if (!hasActive) { %>
                                                                                <tr>
                                                                                    <td colspan="7" class="empty-row">No
                                                                                        active borrows.</td>
                                                                                </tr>
                                                                                <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <div id="tab-penalties" class="tab-content">
                                                        <div class="section-header">
                                                            <h2>💰 My Penalties</h2>
                                                        </div>
                                                        <div class="table-wrap">
                                                            <table class="data-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Book</th>
                                                                        <th>Reason</th>
                                                                        <th>Amount</th>
                                                                        <th>Date</th>
                                                                        <th>Status</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody id="bookTable">
                                                                    <% if (myPenalties.isEmpty()) { %>
                                                                        <tr>
                                                                            <td colspan="5" class="empty-row">No
                                                                                penalties. Keep it up!</td>
                                                                        </tr>
                                                                        <% } else { for (models.Penalty p : myPenalties)
                                                                            { %>
                                                                            <tr>
                                                                                <td>
                                                                                    <%= p.getBookName() %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getReason() %>
                                                                                </td>
                                                                                <td>&#8369;<%= String.format("%.2f",
                                                                                        p.getAmount()) %>
                                                                                </td>
                                                                                <td>
                                                                                    <%= p.getDateRecorded() %>
                                                                                </td>
                                                                                <td>
                                                                                    <% if (p.isSettled()) { %>
                                                                                        <span
                                                                                            class="badge-green">Settled</span>
                                                                                        <% } else { %>
                                                                                            <span
                                                                                                class="badge-red">Unpaid</span>
                                                                                            <% } %>
                                                                                </td>
                                                                            </tr>
                                                                            <% } } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <div id="tab-browse" class="tab-content">
                                                        <div class="section-header">
                                                            <h2>🔍 Browse and Borrow</h2>
                                                            <% if (activeCount>= 3) { %>
                                                                <span class="alert alert-warning"
                                                                    style="font-size:0.85rem;padding:6px 12px">Max 3
                                                                    books reached. Return a book first.</span>
                                                                <% } %>
                                                        </div>
                                                        <div class="table-wrap">
                                                        <div style="margin-bottom:16px;display:flex;gap:10px;flex-wrap:wrap;">
                                                            <input type="text" id="searchInput" placeholder="Search by title or author..." onkeyup="filterBooks()" style="padding:8px 12px;border:1px solid #ddd;border-radius:6px;width:300px;font-size:13px;">
                                                            <select id="categoryFilter" onchange="filterBooks()" style="padding:8px 12px;border:1px solid #ddd;border-radius:6px;font-size:13px;">
                                                                <option value="">All Categories</option>
                                                                <option>Engineering &amp; Technology</option>
                                                                <option>Science</option>
                                                                <option>Mathematics</option>
                                                                <option>Filipino</option>
                                                            </select>
                                                        </div>
                                                            <table class="data-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Book No.</th>
                                                                        <th>Title</th>
                                                                        <th>Author</th>
                                                                        <th>Category</th>
                                                                        <th>Stock</th>
                                                                        <th>Price</th>
                                                                        <th>Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody id="bookTable">
                                                                    <% for (models.Book b : allBooks) { %>
                                                                        <tr>
                                                                            <td><%= b.getBookNo() %></td>


                                                                            <td>
                                                                                <%= b.getName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= b.getAuthor() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= b.getCategory() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= b.getStock() %>
                                                                            </td>
                                                                            <td>&#8369;<%= String.format("%.2f",
                                                                                    b.getPrice()) %>
                                                                            </td>
                                                                            <td>
                                                                                <% if (b.getStock()> 0 && activeCount < 3) { %>
                                                                                    <button type="button" class="btn-sm-green" onclick="openBorrowModal(<%= b.getId() %>, this.getAttribute('data-title'))" data-title="<%= b.getName() %>">Borrow</button>
                                                                                <% } else { %>
                                                                                    <button class="btn-sm-gray" disabled><%= b.getStock()==0 ? "No Stock" : "Max Reached" %></button>
                                                                                <% } %>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>















                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                </div>

                                                <script>
                                                    function showTab(name, el) {
                                                        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
                                                        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                                                        document.getElementById('tab-' + name).classList.add('active');
                                                        el.classList.add('active');
                                                    }
                                                </script>
                                            <script>function filterBooks(){var search=document.getElementById("searchInput").value.toLowerCase();var cat=document.getElementById("categoryFilter").value.toLowerCase();var rows=document.querySelectorAll("#bookTable tr");rows.forEach(function(row){var title=row.cells[1]?row.cells[1].textContent.toLowerCase():"";var author=row.cells[2]?row.cells[2].textContent.toLowerCase():"";var category=row.cells[3]?row.cells[3].textContent.toLowerCase():"";var matchSearch=title.includes(search)||author.includes(search);var matchCat=cat===""||category.includes(cat);row.style.display=matchSearch&&matchCat?"":"none";});}</script>
<form id="globalBorrowForm" action="borrow" method="post" style="display:none"><input type="hidden" name="bookId" id="globalBookId" value=""><input type="hidden" name="days" id="globalDays" value="7"></form><!-- Borrow Modal -->
<div id="borrowModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;justify-content:center;align-items:center;">
  <div style="background:white;border-radius:12px;padding:32px;width:360px;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
    <h3 style="margin-bottom:8px;color:#122146;">Borrow Book</h3>
    <p id="modalBookTitle" style="color:#666;font-size:14px;margin-bottom:20px;"></p>
    <p style="font-weight:600;margin-bottom:12px;color:#333;">How many days do you need?</p>
    <div style="display:flex;gap:10px;margin-bottom:24px;">
      <button onclick="selectDays(3)" id="btn3" class="day-btn" style="flex:1;padding:12px;border:2px solid #ddd;border-radius:8px;cursor:pointer;font-size:16px;font-weight:700;background:white;">3 days</button>
      <button onclick="selectDays(5)" id="btn5" class="day-btn" style="flex:1;padding:12px;border:2px solid #ddd;border-radius:8px;cursor:pointer;font-size:16px;font-weight:700;background:white;">5 days</button>
      <button onclick="selectDays(7)" id="btn7" class="day-btn" style="flex:1;padding:12px;border:2px solid #2E7D32;border-radius:8px;cursor:pointer;font-size:16px;font-weight:700;background:#e8f5e9;color:#2E7D32;">7 days</button>
    </div>
    <div style="display:flex;gap:10px;">
      <button onclick="closeBorrowModal()" style="flex:1;padding:10px;border:1px solid #ddd;border-radius:6px;cursor:pointer;background:white;font-size:14px;">Cancel</button>
      <button onclick="confirmBorrow()" style="flex:1;padding:10px;border:none;border-radius:6px;cursor:pointer;background:#2E7D32;color:white;font-size:14px;font-weight:600;">Confirm Borrow</button>
    </div>
  </div>
</div>
<script>
var currentBookId = null;
var selectedDays = 7;
function openBorrowModal(bookId, bookTitle) {
  currentBookId = bookId;
  selectedDays = 7;
  document.getElementById('modalBookTitle').textContent = bookTitle;
  document.getElementById('borrowModal').style.display = 'flex';
  selectDays(7);
}
function selectDays(days) {
  selectedDays = days;
  [3,5,7].forEach(function(d) {
    var btn = document.getElementById('btn'+d);
    if(d === days) {
      btn.style.border = '2px solid #2E7D32';
      btn.style.background = '#e8f5e9';
      btn.style.color = '#2E7D32';
    } else {
      btn.style.border = '2px solid #ddd';
      btn.style.background = 'white';
      btn.style.color = '#333';
    }
  });
}
function closeBorrowModal() {
  document.getElementById('borrowModal').style.display = 'none';
  currentBookId = null;
}
function confirmBorrow() {
  var f=document.getElementById("globalBorrowForm");
  var bid=document.getElementById("globalBookId");
  var d=document.getElementById("globalDays");
  if(f&&bid&&d){bid.value=currentBookId;d.value=selectedDays;f.submit();}
}
</script>
  }
}
