<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.xml.parsers.*,javax.xml.xpath.*,org.w3c.dom.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    

    <link rel="stylesheet" href="../style.css" />
    
    <title>Article</title>
</head>
<body>
<%
    // Get current session (do not create new one)
    HttpSession ses = request.getSession(false);

    // If user is not logged in, redirect to login page
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    // Get article id from URL parameter (?id=1)
    String id = request.getParameter("id");

    // If no article id is provided
    if (id == null) {
        out.println("No article specified");
        return;
    }

    // Get servlet context to access files inside WEB-INF
    ServletContext ctx = getServletContext();

    try {
        // Create XML document builder
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder dbu = dbf.newDocumentBuilder();

        // Parse content.xml file from WEB-INF
        Document doc = dbu.parse(ctx.getResourceAsStream("/WEB-INF/content.xml"));

        // Create XPath object to search inside XML
        XPath xpath = XPathFactory.newInstance().newXPath();

        // Create XPath expression to find article with matching id
        String expr = "/articles/article[@id='" + id + "']";

        // Find matching article node
        Node node = (Node) xpath.evaluate(expr, doc, XPathConstants.NODE);

        if (node != null) {
            // Get title and body of the article
            String title = xpath.evaluate("title", node);
            String body = xpath.evaluate("body", node);
%>

<!-- Display article title and body -->
<h1><%= title %></h1>
<p><%= body %></p>

<%
        } else {
            // If article not found
            out.println("Article not found");
        }
    } catch (Exception e) {
        // If error happens, throw servlet exception
        throw new ServletException(e);
    }
%>


<a href="home.jsp">Back</a>


<script src="../script.js"></script>
</body>
</html>