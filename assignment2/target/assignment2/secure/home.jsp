<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <!-- security headers via meta just in case -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>Secure Home</title>
    <link rel="stylesheet" href="../style.css" />
    <style>
        body { -webkit-user-select:none; -moz-user-select:none; -ms-user-select:none; user-select:none; }
        @media print { body { display:none !important; } }
    </style>
</head>
<body>
    <div style="display:flex; justify-content:space-between; align-items:center;">
        <h1>Welcome, <%= ses.getAttribute("user") %></h1>
        <a href="../LogoutServlet" style="color:white;text-decoration:none;">Logout</a>
    </div>
    <p style="font-family: 'mencken'; font-size:1.2rem; color:white; margin:8px 0;">Taskly</p>
    <div style="display:flex; gap:20px; margin-top:20px;">
        <a href="page1.jsp" class="box-link">Todo List</a>
        <a href="page2.jsp" class="box-link">My Tasks</a>
        <a href="securepage.jsp" class="box-link">Secure Web Page</a>
    </div>
    </div>

    <script src="../script.js"></script>
</body>
</html>