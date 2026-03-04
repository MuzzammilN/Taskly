<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- disable caching so back button cannot show stale versions -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link rel="stylesheet" href="style.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    <title>Login - Taskly</title>
</head>
<body>
    <div id="main">
        <div id="nav">
            <a href="index.jsp" id="nav_logo">Taskly</a>
        </div>
        
        <div id="form-div">
            <form id="sign" method="post" action="LoginServlet">
                <h2 style="color: white; margin-bottom: 20px;">Login</h2>
                
                <% String error = (String) request.getAttribute("error");
                   if (error != null) { %>
                    <p style="color: #ff6b6b; margin-bottom: 15px;"><%= error %></p>
                <% } %>
                
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required />
                
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required />
                
                <button type="submit">Login</button>
            </form>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>