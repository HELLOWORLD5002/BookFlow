<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>BookFlow — Register</title>
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
                    <h2>Create Account</h2>
                    <p class="login-sub">Register as a student</p>

                    <% String error=(String) request.getAttribute("error"); %>
                        <% String success=(String) request.getAttribute("success"); %>
                            <% if (error !=null) { %>
                                <div class="alert alert-error">
                                    <%= error %>
                                </div>
                                <% } %>
                                    <% if (success !=null) { %>
                                        <div class="alert alert-success">
                                            <%= success %>
                                        </div>
                                        <% } %>

                                            <form action="<%= request.getContextPath() %>/register" method="post">
                                                <div class="form-group">
                                                    <label>Full Name</label>
                                                    <input type="text" name="name" placeholder="e.g. Juan Dela Cruz"
                                                        required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Student Number</label>
                                                    <input type="text" name="studentNumber"
                                                        placeholder="e.g. 2024-123456" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="email" name="email" placeholder="e.g. juan@rtu.edu.ph"
                                                        required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Program</label>
                                                    <select name="program"
                                                        style="width:100%;padding:12px 14px;border:2px solid #D0E8D4;border-radius:8px;font-size:0.95rem;">
                                                        <option value="BS Computer Engineering">BS Computer Engineering
                                                        </option>
                                                        <option value="BS Information Technology">BS Information
                                                            Technology</option>
                                                        <option value="BS Computer Science">BS Computer Science</option>
                                                        <option value="BS Electronics Engineering">BS Electronics
                                                            Engineering</option>
                                                        <option value="BS Electrical Engineering">BS Electrical
                                                            Engineering</option>
                                                        <option value="BS Mechanical Engineering">BS Mechanical
                                                            Engineering</option>
                                                        <option value="BS Civil Engineering">BS Civil Engineering
                                                        </option>
                                                        <option value="Other">Other</option>
                                                        <option value="Other">Other (please specify)</option>
                                                    </select>
                                                    <div id="otherProgramDiv" style="display:none;margin-top:8px;"><input type="text" name="otherProgram" id="otherProgramInput" placeholder="e.g. BS Architecture" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:8px;font-size:14px;"></div>
                                                    <label>Password</label>
                                                    <input type="password" name="password"
                                                        placeholder="Create a password" required>
                                                </div>
                                                <button type="submit" class="btn-login">Create Account</button>
                                            </form>
                                            <div class="login-footer">
                                                <p>Already have an account? <a
                                                        href="<%= request.getContextPath() %>/pages/login.jsp"
                                                        style="color:#2E7D32;font-weight:600;">Sign In</a></p>
                                                <p class="rtu-tag">Rizal Technological University</p>
                                            </div>
                </div>
            </div>
        </div>
    </body>

    </html>
