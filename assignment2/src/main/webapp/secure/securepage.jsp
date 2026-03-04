<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.Base64" %>
<%

    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String currentUser = (String) ses.getAttribute("user");


    if ("logout".equals(request.getParameter("action"))) {
        ses.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }


    String download = request.getParameter("download");
    if (download != null && "hary".equals(download)) {
        File bookFile = new File(getServletContext().getRealPath("/WEB-INF/images/hary.jpg"));
        if (bookFile.exists()) {
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"hary.jpg\"");
            response.setContentLengthLong(bookFile.length());

            try (FileInputStream fis = new FileInputStream(bookFile);
                 OutputStream os = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>Secure Book Page</title>
    <link rel="stylesheet" href="../style.css" />
    <style>
        body { 
            user-select: none; 
            -webkit-user-select: none; 
            -moz-user-select: none; 
            -ms-user-select: none; 
            color: #fff; 
            background-color: #222; 
            padding: 20px;
        }
        @media print { body { display: none !important; } }
        .book-container { display:flex; flex-direction:column; align-items:center; gap:10px; margin-top:20px; }
        .book-container img { width:250px; height:auto; border:1px solid #ddd; border-radius:5px; }
        .btn { background-color:#007bff; color:white; padding:8px 12px; text-decoration:none; border-radius:4px; }
    </style>
    <script>
      
        document.addEventListener('contextmenu', e => e.preventDefault());

      
        document.addEventListener('copy', e => e.preventDefault());
        document.addEventListener('cut', e => e.preventDefault());
        document.addEventListener('paste', e => e.preventDefault());

      
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && (e.key === 'p' || e.key === 'P')) e.preventDefault();
            if (e.key === 'PrintScreen') e.preventDefault();
        });

        
        document.addEventListener('dragstart', e => e.preventDefault());
        document.addEventListener('drop', e => e.preventDefault());
    </script>
</head>
<body>
    <div style="display:flex; justify-content:space-between; align-items:center;">
        <h1>Secure Book Page</h1>
        <a href="secureBook.jsp?action=logout">Logout</a>
    </div>
    <p>Welcome, <strong><%= currentUser %></strong></p>
    <p>All content is secure: copy, print, or direct download of files is restricted.</p>

    <div class="book-container">
        <h3>Book: hary.jpg</h3>
        <%
            File bookFile = new File(getServletContext().getRealPath("/WEB-INF/images/hary.jpg"));
            if (bookFile.exists()) {
                try (FileInputStream fis = new FileInputStream(bookFile)) {
                    byte[] imgBytes = fis.readAllBytes();
                    String base64Img = Base64.getEncoder().encodeToString(imgBytes);
        %>
        <img src="data:image/jpeg;base64,<%= base64Img %>" alt="Book Image" />
        <%
                } catch(Exception e) {
                    out.println("<p style='color:red;'>Error loading book image.</p>");
                }
            } else {
                out.println("<p style='color:red;'>Book image not found.</p>");
            }
        %>
    </div>
</body>
</html>