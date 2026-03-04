<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.io.*,java.util.Base64" %>
<%
    // Get current session (do not create new one)
    HttpSession ses = request.getSession(false);

    // If user is not logged in, redirect to login page
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get logged-in username
    String currentUser = (String) ses.getAttribute("user");

    // If user clicks logout link
    if ("logout".equals(request.getParameter("action"))) {
        ses.invalidate(); // destroy session
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Check if user is requesting file download
    String download = request.getParameter("download");

    // If download parameter equals "hary"
    if (download != null && "hary".equals(download)) {

        // Get book file from WEB-INF (protected folder)
        File bookFile = new File(getServletContext().getRealPath("/WEB-INF/images/hary.jpg"));

        if (bookFile.exists()) {

            // Prevent caching
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Force browser to download file
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"hary.jpg\"");
            response.setContentLengthLong(bookFile.length());

            // Read file and send to browser
            try (FileInputStream fis = new FileInputStream(bookFile);
                 OutputStream os = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // If file does not exist
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
        /* Disable text selection */
        body { 
            user-select: none; 
            -webkit-user-select: none; 
            -moz-user-select: none; 
            -ms-user-select: none; 
            color: #fff; 
            background-color: #222; 
            padding: 20px;
        }

        /* Hide page when printing */
        @media print { body { display: none !important; } }

        .book-container { 
            display:flex; 
            flex-direction:column; 
            align-items:center; 
            gap:10px; 
            margin-top:20px; 
        }

        .book-container img { 
            width:250px; 
            height:auto; 
            border:1px solid #ddd; 
            border-radius:5px; 
        }

        .btn { 
            background-color:#007bff; 
            color:white; 
            padding:8px 12px; 
            text-decoration:none; 
            border-radius:4px; 
        }
    </style>

    <script>
        // Disable right-click
        document.addEventListener('contextmenu', e => e.preventDefault());

        // Disable copy, cut, paste
        document.addEventListener('copy', e => e.preventDefault());
        document.addEventListener('cut', e => e.preventDefault());
        document.addEventListener('paste', e => e.preventDefault());

        // Disable print and PrintScreen key
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && (e.key === 'p' || e.key === 'P')) e.preventDefault();
            if (e.key === 'PrintScreen') e.preventDefault();
        });

        // Disable drag and drop
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
            // Load book image from WEB-INF
            File bookFile = new File(getServletContext().getRealPath("/WEB-INF/images/hary.jpg"));

            if (bookFile.exists()) {
                try (FileInputStream fis = new FileInputStream(bookFile)) {

                    // Read image bytes
                    byte[] imgBytes = fis.readAllBytes();

                    // Convert image to Base64
                    String base64Img = Base64.getEncoder().encodeToString(imgBytes);
        %>

        <!-- Display image using Base64 -->
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