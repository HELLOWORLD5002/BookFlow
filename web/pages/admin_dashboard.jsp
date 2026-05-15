@"
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List, models.*, java.time.LocalDate" %>
        <% String adminName=(String) session.getAttribute("adminName"); if (adminName==null) {
            response.sendRedirect(request.getContextPath() + "/login" ); return; } List<models.Transaction> transactions
            = (List<models.Transaction>) request.getAttribute("transactions");
                List<models.Book> books = (List<models.Book>) request.getAttribute("books");
                        List<models.Student> students = (List<models.Student>) request.getAttribute("students");
                                List<models.Penalty> penalties = (List<models.Penalty>)
                                        request.getAttribute("penalties");
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
                                                        "@ | Set-Content web\pages\admin_dashboard.jsp
                                                        <style>
                                                            *,
                                                            *::before,
                                                            *::after {
                                                                box-sizing: border-box;
                                                                margin: 0;
                                                                padding: 0;
                                                            }

                                                            :root {
                                                                --navy: #122146;
                                                                --sidebar: #0c1837;
                                                                --gold: #c8960a;
                                                                --gold-light: #f0b429;
                                                                --white: #fff;
                                                                --gray-bg: #f4f6fb;
                                                                --text: #1a1a2e;
                                                                --muted: #6b7280;
                                                                --green: #16a34a;
                                                                --yellow: #ca8a04;
                                                                --orange: #ea580c;
                                                                --red: #dc2626;
                                                                --row-green: #dcfce7;
                                                                --row-yellow: #fefce8;
                                                                --row-orange: #fff7ed;
                                                                --row-red: #fef2f2;
                                                                --row-gray: #f3f4f6;
                                                                --sidebar-w: 220px;
                                                            }

                                                            body {
                                                                font-family: 'DM Sans', sans-serif;
                                                                background: var(--gray-bg);
                                                                color: var(--text);
                                                                display: flex;
                                                                min-height: 100vh;
                                                            }

                                                            .sidebar {
                                                                width: var(--sidebar-w);
                                                                background: var(--sidebar);
                                                                position: fixed;
                                                                top: 0;
                                                                left: 0;
                                                                height: 100vh;
                                                                display: flex;
                                                                flex-direction: column;
                                                                z-index: 100;
                                                            }

                                                            .sidebar-brand {
                                                                padding: 28px 24px 20px;
                                                                border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                                                            }

                                                            .sidebar-brand h1 {
                                                                font-family: 'Playfair Display', serif;
                                                                color: var(--gold-light);
                                                                font-size: 1.5rem;
                                                            }

                                                            .sidebar-brand p {
                                                                color: rgba(255, 255, 255, 0.4);
                                                                font-size: 0.72rem;
                                                                letter-spacing: 0.5px;
                                                                margin-top: 2px;
                                                            }

                                                            .sidebar-user {
                                                                padding: 16px 24px;
                                                                border-bottom: 1px solid rgba(255, 255, 255, 0.08);
                                                            }

                                                            .sidebar-user .role {
                                                                color: rgba(255, 255, 255, 0.4);
                                                                font-size: 0.72rem;
                                                                text-transform: uppercase;
                                                                letter-spacing: 1px;
                                                            }

                                                            .sidebar-user .name {
                                                                color: var(--white);
                                                                font-size: 0.9rem;
                                                                font-weight: 600;
                                                                margin-top: 2px;
                                                            }

                                                            .sidebar-nav {
                                                                flex: 1;
                                                                padding: 16px 0;
                                                            }

                                                            .nav-item {
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 10px;
                                                                padding: 11px 24px;
                                                                color: rgba(255, 255, 255, 0.6);
                                                                font-size: 0.88rem;
                                                                cursor: pointer;
                                                                transition: all 0.2s;
                                                                text-decoration: none;
                                                                border-left: 3px solid transparent;
                                                            }

                                                            .nav-item:hover,
                                                            .nav-item.active {
                                                                color: var(--white);
                                                                background: rgba(255, 255, 255, 0.07);
                                                                border-left-color: var(--gold-light);
                                                            }

                                                            .sidebar-logout {
                                                                padding: 16px 24px;
                                                                border-top: 1px solid rgba(255, 255, 255, 0.08);
                                                            }

                                                            .logout-btn {
                                                                display: flex;
                                                                align-items: center;
                                                                gap: 8px;
                                                                color: rgba(255, 255, 255, 0.4);
                                                                font-size: 0.85rem;
                                                                text-decoration: none;
                                                            }

                                                            .logout-btn:hover {
                                                                color: #fc8181;
                                                            }

                                                            .main {
                                                                margin-left: var(--sidebar-w);
                                                                flex: 1;
                                                                display: flex;
                                                                flex-direction: column;
                                                            }

                                                            .topbar {
                                                                background: var(--white);
                                                                padding: 16px 32px;
                                                                border-bottom: 1px solid #e5e7eb;
                                                                display: flex;
                                                                align-items: center;
                                                                justify-content: space-between;
                                                            }

                                                            .topbar h2 {
                                                                font-size: 1.1rem;
                                                                font-weight: 600;
                                                            }

                                                            .topbar .date {
                                                                color: var(--muted);
                                                                font-size: 0.82rem;
                                                            }

                                                            .content {
                                                                padding: 28px 32px;
                                                                flex: 1;
                                                            }

                                                            .stats-grid {
                                                                display: grid;
                                                                grid-template-columns: repeat(4, 1fr);
                                                                gap: 16px;
                                                                margin-bottom: 28px;
                                                            }

                                                            .stat-card {
                                                                background: var(--white);
                                                                border-radius: 14px;
                                                                padding: 20px 22px;
                                                                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
                                                                border-left: 4px solid var(--navy);
                                                            }

                                                            .stat-card.gold {
                                                                border-left-color: var(--gold);
                                                            }

                                                            .stat-card.green {
                                                                border-left-color: var(--green);
                                                            }

                                                            .stat-card.red {
                                                                border-left-color: var(--red);
                                                            }

                                                            .stat-card.orange {
                                                                border-left-color: var(--orange);
                                                            }

                                                            .stat-label {
                                                                font-size: 0.75rem;
                                                                color: var(--muted);
                                                                text-transform: uppercase;
                                                                letter-spacing: 0.5px;
                                                                margin-bottom: 6px;
                                                            }

                                                            .stat-value {
                                                                font-size: 1.9rem;
                                                                font-weight: 700;
                                                                color: var(--text);
                                                                line-height: 1;
                                                            }

                                                            .stat-sub {
                                                                font-size: 0.75rem;
                                                                color: var(--muted);
                                                                margin-top: 4px;
                                                            }

                                                            .tab-bar {
                                                                display: flex;
                                                                gap: 4px;
                                                                background: var(--white);
                                                                border-radius: 12px;
                                                                padding: 6px;
                                                                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
                                                                margin-bottom: 20px;
                                                                width: fit-content;
                                                            }

                                                            .tab {
                                                                padding: 8px 18px;
                                                                border: none;
                                                                background: transparent;
                                                                border-radius: 8px;
                                                                font-family: 'DM Sans', sans-serif;
                                                                font-size: 0.85rem;
                                                                font-weight: 500;
                                                                color: var(--muted);
                                                                cursor: pointer;
                                                                transition: all 0.2s;
                                                            }

                                                            .tab.active {
                                                                background: var(--navy);
                                                                color: var(--white);
                                                            }

                                                            .panel {
                                                                display: none;
                                                            }

                                                            .panel.active {
                                                                display: block;
                                                            }

                                                            .table-card {
                                                                background: var(--white);
                                                                border-radius: 14px;
                                                                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
                                                                overflow: hidden;
                                                            }

                                                            .table-header {
                                                                padding: 18px 22px;
                                                                border-bottom: 1px solid #f3f4f6;
                                                            }

                                                            .table-header h3 {
                                                                font-size: 0.95rem;
                                                                font-weight: 600;
                                                            }

                                                            .badge {
                                                                display: inline-block;
                                                                padding: 3px 10px;
                                                                border-radius: 20px;
                                                                font-size: 0.75rem;
                                                                font-weight: 600;
                                                            }

                                                            .badge.green {
                                                                background: #dcfce7;
                                                                color: var(--green);
                                                            }

                                                            .badge.red {
                                                                background: #fef2f2;
                                                                color: var(--red);
                                                            }

                                                            .badge.yellow {
                                                                background: #fefce8;
                                                                color: var(--yellow);
                                                            }

                                                            .badge.orange {
                                                                background: #fff7ed;
                                                                color: var(--orange);
                                                            }

                                                            .badge.gray {
                                                                background: #f3f4f6;
                                                                color: var(--muted);
                                                            }

                                                            .badge.navy {
                                                                background: #e0e7ff;
                                                                color: var(--navy);
                                                            }

                                                            table {
                                                                width: 100%;
                                                                border-collapse: collapse;
                                                                font-size: 0.85rem;
                                                            }

                                                            th {
                                                                background: #f8fafc;
                                                                padding: 11px 16px;
                                                                text-align: left;
                                                                font-size: 0.75rem;
                                                                font-weight: 600;
                                                                color: var(--muted);
                                                                text-transform: uppercase;
                                                                letter-spacing: 0.5px;
                                                                border-bottom: 1px solid #f3f4f6;
                                                            }

                                                            td {
                                                                padding: 11px 16px;
                                                                border-bottom: 1px solid #f9fafb;
                                                                vertical-align: middle;
                                                            }

                                                            tr:last-child td {
                                                                border-bottom: none;
                                                            }

                                                            tr.row-green {
                                                                background: var(--row-green);
                                                            }

                                                            tr.row-yellow {
                                                                background: var(--row-yellow);
                                                            }

                                                            tr.row-orange {
                                                                background: var(--row-orange);
                                                            }

                                                            tr.row-red {
                                                                background: var(--row-red);
                                                            }

                                                            tr.row-gray {
                                                                background: var(--row-gray);
                                                            }

                                                            .empty-msg {
                                                                text-align: center;
                                                                padding: 40px;
                                                                color: var(--muted);
                                                                font-size: 0.88rem;
                                                            }
                                                        </style>
                                                        </head>

                                                        <body>
                                                            <aside class="sidebar">
                                                                <div class="sidebar-brand">
                                                                    <h1>BookFlow</h1>
                                                                    <p>RTU Library System</p>
                                                                </div>
                                                                <div class="sidebar-user">
                                                                    <div class="role">Admin Panel</div>
                                                                    <div class="name">ðŸ‘¤ <%= adminName %>
                                                                    </div>
                                                                </div>
                                                                <nav class="sidebar-nav">
                                                                    <a class="nav-item active"
                                                                        onclick="showTab('transactions')"><span>ðŸ“‹</span>
                                                                        Transactions</a>
                                                                    <a class="nav-item"
                                                                        onclick="showTab('books')"><span>ðŸ“š</span>
                                                                        Books</a>
                                                                    <a class="nav-item"
                                                                        onclick="showTab('students')"><span>ðŸ‘¥</span>
                                                                        Students</a>
                                                                    <a class="nav-item"
                                                                        onclick="showTab('penalties')"><span>ðŸ’°</span>
                                                                        Penalties</a>
                                                                </nav>
                                                                <div class="sidebar-logout">
                                                                    <a href="<%= request.getContextPath() %>/logout"
                                                                        class="logout-btn">ðŸšª Logout</a>
                                                                </div>
                                                            </aside>
                                                            <div class="main">
                                                                <div class="topbar">
                                                                    <h2 id="topbar-title">All Transactions</h2>
                                                                    <span class="date">BookFlow Admin Dashboard</span>
                                                                </div>
                                                                <div class="content">
                                                                    <div class="stats-grid">
                                                                        <div class="stat-card gold">
                                                                            <div class="stat-label">Total Books</div>
                                                                            <div class="stat-value">
                                                                                <%= totalBooks %>
                                                                            </div>
                                                                            <div class="stat-sub">
                                                                                <%= availableBooks %> available
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-card green">
                                                                            <div class="stat-label">Students</div>
                                                                            <div class="stat-value">
                                                                                <%= totalStudents %>
                                                                            </div>
                                                                            <div class="stat-sub">registered accounts
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-card red">
                                                                            <div class="stat-label">Overdue</div>
                                                                            <div class="stat-value">
                                                                                <%= overdueCount %>
                                                                            </div>
                                                                            <div class="stat-sub">active overdue books
                                                                            </div>
                                                                        </div>
                                                                        <div class="stat-card orange">
                                                                            <div class="stat-label">Unpaid Fines</div>
                                                                            <div class="stat-value">â‚±<%=
                                                                                    String.format("%.0f", unpaidTotal)
                                                                                    %>
                                                                            </div>
                                                                            <div class="stat-sub">total outstanding
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="tab-bar">
                                                                        <button class="tab active"
                                                                            onclick="showTab('transactions')">ðŸ“‹
                                                                            Transactions</button>
                                                                        <button class="tab"
                                                                            onclick="showTab('books')">ðŸ“š Books</button>
                                                                        <button class="tab"
                                                                            onclick="showTab('students')">ðŸ‘¥
                                                                            Students</button>
                                                                        <button class="tab"
                                                                            onclick="showTab('penalties')">ðŸ’°
                                                                            Penalties</button>
                                                                    </div>

                                                                    <div id="panel-transactions" class="panel active">
                                                                        <div class="table-card">
                                                                            <div class="table-header">
                                                                                <h3>All Transactions</h3>
                                                                            </div>
                                                                            <% if (transactions.isEmpty()) { %>
                                                                                <div class="empty-msg">No transactions
                                                                                    yet.</div>
                                                                                <% } else { %>
                                                                                    <table>
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Student</th>
                                                                                                <th>Book</th>
                                                                                                <th>Borrowed</th>
                                                                                                <th>Due Date</th>
                                                                                                <th>Status</th><th>Action</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% for (models.Transaction t
                                                                                                : transactions) { String
                                                                                                rowClass="row-green" ;
                                                                                                if
                                                                                                (t.isReturned())
                                                                                                rowClass="row-gray" ;
                                                                                                else if
                                                                                                (t.daysOverdue() > 0)
                                                                                                rowClass="row-red" ; %>
                                                                                                <tr
                                                                                                    class="<%= rowClass %>">
                                                                                                    <td><strong>
                                                                                                            <%= t.getStudentName()
                                                                                                                %>
                                                                                                        </strong></td>
                                                                                                    <td>
                                                                                                        <%= t.getBookName()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= t.getBorrowDate()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= t.getExpectedReturn()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td><span
                                                                                                            class="badge">
                                                                                                            <%= t.getStatusLabel()
                                                                                                                %>
                                                                                                        </span>
</td><td><% if(!t.isReturned()){ %><form method="post" action="<%= request.getContextPath() %>/adminreturn" style="display:inline"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><input type="hidden" name="type" value="returned"><button type="submit" style="background:#2E7D32;color:white;border:none;padding:4px 8px;border-radius:4px;cursor:pointer;margin:2px">Return</button></form><form method="post" action="<%= request.getContextPath() %>/adminreturn" style="display:inline"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><input type="hidden" name="type" value="damaged"><button type="submit" style="background:#e67e22;color:white;border:none;padding:4px 8px;border-radius:4px;cursor:pointer;margin:2px">Damaged</button></form><form method="post" action="<%= request.getContextPath() %>/adminreturn" style="display:inline"><input type="hidden" name="transactionId" value="<%= t.getId() %>"><input type="hidden" name="type" value="lost"><button type="submit" style="background:#c0392b;color:white;border:none;padding:4px 8px;border-radius:4px;cursor:pointer;margin:2px">Lost</button></form><% } %></td>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <% } %>
                                                                        </div>
                                                                    </div>

                                                                    <div id="panel-books" class="panel">
                                                                        <div class="table-card">
                                                                            <div class="table-header">
                                                                                <h3>?? Book Inventory</h3></div><div style="padding:16px;background:#f0f4f0;border-radius:8px;margin:16px 16px 0 16px"><form method="post" action="<%= request.getContextPath() %>/addbook" style="display:flex;flex-wrap:wrap;gap:8px;align-items:center"><input name="title" placeholder="Title*" required style="padding:8px;border:1px solid #ccc;border-radius:4px;flex:1;min-width:120px"><input name="author" placeholder="Author*" required style="padding:8px;border:1px solid #ccc;border-radius:4px;flex:1;min-width:120px"><select name="category" style="padding:8px;border:1px solid #ccc;border-radius:4px"><option>Engineering</option><option>Science</option><option>Mathematics</option><option>Fiction</option><option>Programming</option><option>Database</option><option>Networking</option><option>Technology</option><option>Economics</option><option>Systems</option></select><input name="copies" type="number" value="1" min="1" style="padding:8px;border:1px solid #ccc;border-radius:4px;width:70px"><button type="submit" style="padding:8px 16px;background:#2E7D32;color:white;border:none;border-radius:4px;cursor:pointer">Add Book</button></form>
                                                                            </div>
                                                                            <table>
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>Book No.</th>
                                                                                        <th>Title</th>
                                                                                        <th>Author</th>
                                                                                        <th>Category</th>
                                                                                        <th>Stock</th>
                                                                                        
                                                                                        <th>Status</th><th>Action</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% for (models.Book b : books) { %>
                                                                                        <tr>
                                                                                            <td><span
                                                                                                    class="badge navy">
                                                                                                    <%= String.valueOf(b.getId()) %>
                                                                                                </span></td>
                                                                                            <td><strong>
                                                                                                    <%= b.getTitle() %>
                                                                                                </strong></td>
                                                                                            <td>
                                                                                                <%= b.getAuthor() %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <%= b.getCategory() %>
                                                                                            </td>
                                                                                            <td>
                                                                                                <%= b.getStock() %>
                                                                                            </td>
                                                                                            <td>â‚±<%= String.format("%.2f",
                                                                                                    b.getPrice()) %>
                                                                                            </td>
                                                                                            <td><span class="badge">
                                                                                                    <%= b.getStatus() %></span></td><td><form method="post" action="<%= request.getContextPath() %>/deletebook"><input type="hidden" name="bookId" value="<%= b.getId() %>"><button type="submit" style="background:#c0392b;color:white;border:none;padding:4px 10px;border-radius:4px;cursor:pointer;">Delete</button></form>
                                                                                                </span></td>
                                                                                        </tr>
                                                                                        <% } %>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>

                                                                    <div id="panel-students" class="panel">
                                                                        <div class="table-card">
                                                                            <div class="table-header">
                                                                                <h3>ðŸ‘¥ Registered Students</h3>
                                                                            </div>
                                                                            <% if (students.isEmpty()) { %>
                                                                                <div class="empty-msg">No students
                                                                                    registered yet.</div>
                                                                                <% } else { %>
                                                                                    <table>
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Name</th>
                                                                                                <th>Student No.</th>
                                                                                                <th>Email</th>
                                                                                                <th>Program</th>
                                                                                                <th>Warning</th><th>Action</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% for (models.Student s :
                                                                                                students) { %>
                                                                                                <tr>
                                                                                                    <td><strong>
                                                                                                            <%= s.getName()
                                                                                                                %>
                                                                                                        </strong></td>
                                                                                                    <td>
                                                                                                        <%= s.getStudentNumber()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= s.getEmail()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= s.getProgram()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td><span
                                                                                                            class="badge">
                                                                                                            <%= s.warningLabel()
                                                                                                                %>
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <% } %>
                                                                        </div>
                                                                    </div>

                                                                    <div id="panel-penalties" class="panel">
                                                                        <div class="table-card">
                                                                            <div class="table-header">
                                                                                <h3>ðŸ’° Penalties</h3>
                                                                            </div>
                                                                            <% if (penalties.isEmpty()) { %>
                                                                                <div class="empty-msg">No penalties
                                                                                    recorded yet.</div>
                                                                                <% } else { %>
                                                                                    <table>
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Student</th>
                                                                                                <th>Book</th>
                                                                                                <th>Type</th>
                                                                                                <th>Amount</th>
                                                                                                <th>Date</th>
                                                                                                <th>Status</th><th>Action</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% for (models.Penalty p :
                                                                                                penalties) { %>
                                                                                                <% String prc=p.isSettled()
                                                                                                    ? "row-gray"
                                                                                                    : "row-red" ; %>
                                                                                                    <tr
                                                                                                        class="<%= prc %>">
                                                                                                        <td><strong>
                                                                                                                <%= p.getStudentName()
                                                                                                                    %>
                                                                                                            </strong>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= p.getBookName()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td><span
                                                                                                                class="badge orange">
                                                                                                                <%= p.getReason()
                                                                                                                    %>
                                                                                                            </span></td>
                                                                                                        <td><strong>â‚±<%=
                                                                                                                    String.format("%.2f",
                                                                                                                    p.getAmount())
                                                                                                                    %>
                                                                                                            </strong>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= p.getDateRecorded()
                                                                                                                %>
                                                                                                        </td>


                                                                                                                <%= p.isSettled() ? "Paid" : "Unpaid" %>
                                                                                                            </span></td>
                                                                                                            <td><% if(!p.isSettled()){ %><form action="<%= request.getContextPath() %>/settle" method="POST" style="display:inline;"><input type="hidden" name="penaltyId" value="<%= p.getId() %>"><button type="submit" style="background:#2E7D32;color:white;border:none;padding:4px 12px;border-radius:4px;cursor:pointer;font-size:12px;">Settle</button></form><% } %></td>
                                                                                                                    %>
                                                                                                            </span>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <% } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <% } %>
                                                                        </div>
                                                                    </div>

                                                                </div>
                                                            </div>
                                                            <script>
                                                                function showTab(name) {
                                                                    document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
                                                                    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                                                                    document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                                                                    document.getElementById('panel-' + name).classList.add('active');
                                                                    document.querySelectorAll('.tab').forEach(t => { if (t.textContent.toLowerCase().includes(name.substring(0, 4))) t.classList.add('active'); });
                                                                    document.querySelectorAll('.nav-item').forEach(n => { if (n.textContent.toLowerCase().includes(name.substring(0, 4))) n.classList.add('active'); });
                                                                    const titles = { transactions: 'All Transactions', books: 'Book Inventory', students: 'Students', penalties: 'Penalties' };
                                                                    document.getElementById('topbar-title').textContent = titles[name];
                                                                }
                                                            </script>
                                                        </body>

                                                        </html>

