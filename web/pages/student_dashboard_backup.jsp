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
                                                <title>BookFlow — Student Portal</title>
                                                <link rel="stylesheet" href="../css/style.css">
                                            </head>

                                            <body class="dashboard-body">

                                                <!-- SIDEBAR -->
                                                <div class="sidebar">
                                                    <div class="sidebar-brand">📚 BookFlow</div>
                                                    <div class="sidebar-role">Student Portal</div>
                                                    <nav class="sidebar-nav">
                                                        <a href="#" class="nav-item active"
                                                            onclick="showTab('overview')">🏠 Overview</a>
                                                        <a href="#" class="nav-item" onclick="showTab('borrowed')">📖 My
                                                            Books</a>
                                                        <a href="#" class="nav-item" onclick="showTab('penalties')">💰
                                                            My Penalties</a>
                                                        <a href="#" class="nav-item" onclick="showTab('browse')">🔍
                                                            Browse &amp; Borrow</a>
                                                    </nav>
                                                    <div class="sidebar-bottom">
                                                        <div class="admin-info">👤 <%= studentName %>
                                                        </div>
                                                        <a href="<%= request.getContextPath() %>/logout"
                                                            class="btn-logout">Logout</a>
                                                    </div>
                                                </div>

                                                <!-- MAIN CONTENT -->
                                                <div class="main-content">

                                                    <!-- OVERVIEW TAB -->
                                                    <div id="tab-overview" class="tab-content active">
                                                        <h2>Welcome, <%= studentName %>! 👋</h2>
                                                        <p class="student-num">Student No: <%= studentNumber %>
                                                        </p>

                                                        <% if (currentStudent !=null &&
                                                            currentStudent.getWarningCount()> 0) { %>
                                                            <div class="alert alert-warning">
                                                                ⚠️ Warning Level: <strong>
                                                                    <%= currentStudent.warningLabel() %>
                                                                </strong>
                                                                <% if (currentStudent.isCriticalBlocked()) { %>
                                                                    — Your account is BLOCKED. Contact the library
                                                                    admin.
                                                                    <% } %>
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
                                                                        <div class="stat-num">₱<%= String.format("%.2f",
                                                                                totalFines) %>
                                                                        </div>
                                                                        <div class="stat-label">Total Fines</div>
                                                                    </div>
                                                                </div>
                                                    </div>

                                                    <!-- MY BOOKS TAB -->
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
                                                                <tbody>
                                                                    <% for (models.Transaction t : myTransactions) { if
                                                                        (t.isReturned()) continue; %>
                                                                        <tr
                                                                            style="background-color: <%= t.getRowColor() %>">
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
                                                                            <td>
                                                                                <%= t.getStatusLabel() %>
                                                                            </td>
                                                                            <td>₱<%= String.format("%.2f",
                                                                                    t.computeOverdueFine()) %>
                                                                            </td>
                                                                            <td>
                                                                                <form
                                                                                    action="<%= request.getContextPath() %>/return"
                                                                                    method="post"
                                                                                    style="display:inline">
                                                                                    <input type="hidden"
                                                                                        name="transactionId"
                                                                                        value="<%= t.getId() %>">
                                                                                    <button type="submit"
                                                                                        class="btn-sm-green">Return</button>
                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                            <% if (myTransactions.stream().noneMatch(t
                                                                                -> !t.isReturned())) { %>
                                                                                <tr>
                                                                                    <td colspan="7" class="empty-row">No
                                                                                        active borrows.</td>
                                                                                </tr>
                                                                                <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <!-- PENALTIES TAB -->
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
                                                                <tbody>
                                                                    <% for (models.Penalty p : myPenalties) { %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= p.getBookName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= p.getReason() %>
                                                                            </td>
                                                                            <td>₱<%= String.format("%.2f",
                                                                                    p.getAmount()) %>
                                                                            </td>
                                                                            <td>
                                                                                <%= p.getDateRecorded() %>
                                                                            </td>
                                                                            <td><span class="badge-status"><%= p.isSettled()
                                                                                        ? "Settled" : "Unpaid" %></span>
                                                                            </td>
                                                                        </tr>
                                                                        <% } %>
                                                                            <% if (myPenalties.isEmpty()) { %>
                                                                                <tr>
                                                                                    <td colspan="5" class="empty-row">No
                                                                                        penalties. Keep it up! 🎉</td>
                                                                                </tr>
                                                                                <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                    <!-- BROWSE & BORROW TAB -->
                                                    <div id="tab-browse" class="tab-content">
                                                        <div class="section-header">
                                                            <h2>🔍 Browse &amp; Borrow</h2>
                                                            <% if (activeCount>= 3) { %>
                                                                <span class="alert alert-warning"
                                                                    style="font-size:0.85rem">Max 3 books reached.
                                                                    Return a book first.</span>
                                                                <% } %>
                                                        </div>
                                                        <div class="table-wrap">
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
                                                                <tbody>
                                                                    <% for (models.Book b : allBooks) { %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= b.getBookNo() %>
                                                                            </td>
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
                                                                            <td>₱<%= String.format("%.2f", b.getPrice())
                                                                                    %>
                                                                            </td>
                                                                            <td>
                                                                                <% if (b.getStock()> 0 && activeCount <
                                                                                        3) { %>
                                                                                        <form
                                                                                            action="<%= request.getContextPath() %>/borrow"
                                                                                            method="post"
                                                                                            style="display:inline">
                                                                                            <input type="hidden"
                                                                                                name="bookNo"
                                                                                                value="<%= b.getBookNo() %>">
                                                                                            <button type="submit"
                                                                                                class="btn-sm-green">Borrow</button>
                                                                                        </form>
                                                                                        <% } else { %>
                                                                                            <button class="btn-sm-gray"
                                                                                                disabled>Unavailable</button>
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
                                                    function showTab(name) {
                                                        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
                                                        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                                                        document.getElementById('tab-' + name).classList.add('active');
                                                        event.target.classList.add('active');
                                                    }
                                                </script>
                                            </body>

                                            </html>
