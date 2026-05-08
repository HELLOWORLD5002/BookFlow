<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>BookFlow — RTU Library</title>
        <link rel="stylesheet" href="/BookFlow/css/style.css">
    </head>

    <body class="login-body">

        <div class="login-wrapper">
            <div class="login-left">
                <div class="login-brand">
                    <div class="brand-icon">📚</div>
                    <h1>BookFlow</h1>
                    <p>RTU Digital Library Management System</p>
                </div>
                <div class="login-features">
                    <div class="feature-item">✅ Borrow &amp; Return Books</div>
                    <div class="feature-item">📊 Track Penalties</div>
                    <div class="feature-item">🔔 Warning System</div>
                    <div class="feature-item">📁 Full Inventory</div>
                </div>
            </div>

            <div class="login-right">
                <div class="login-card">
                    <h2>Welcome Back</h2>
                    <p class="login-sub">Sign in to your account</p>

                    <% String error=(String) request.getAttribute("error"); %>
                        <% if (error !=null) { %>
                            <div class="alert alert-error">
                                <%= error %>
                            </div>
                            <% } %>

                                <form action="<%= request.getContextPath() %>/login" method="post">
                                    <div class="tab-switch">
                                        <button type="button" class="tab-btn active"
                                            onclick="switchRole('student')">Student</button>
                                        <button type="button" class="tab-btn"
                                            onclick="switchRole('admin')">Admin</button>
                                    </div>
                                    <input type="hidden" name="role" id="roleInput" value="student" id="roleInput">

                                    <div class="form-group">
                                        <label>Student Number / Username</label>
                                        <input type="text" name="username" placeholder="e.g. 2021-12345" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input type="password" name="password" placeholder="Enter your password"
                                            required>
                                    </div>
                                    <button type="submit" class="btn-login">Sign In</button>
                                </form>

                                <div class="login-footer">
                                    <p>No account? <a href="register.jsp" style="color:#2E7D32;font-weight:600;">Register here</a></p>
                                    <p class="rtu-tag">Rizal Technological University</p>
                                </div>
                </div>
            </div>
        </div>

        <script>
            function switchRole(role) {
                document.getElementById('roleInput').value = role;
                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                event.target.classList.add('active');
            }
        </script>
    </body>

    </html>
