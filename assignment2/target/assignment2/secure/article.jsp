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
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
    String id = request.getParameter("id");
    if (id == null) {
        out.println("No article specified");
        return;
    }
    ServletContext ctx = getServletContext();
    try {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder dbu = dbf.newDocumentBuilder();
        Document doc = dbu.parse(ctx.getResourceAsStream("/WEB-INF/content.xml"));
        XPath xpath = XPathFactory.newInstance().newXPath();
        String expr = "/articles/article[@id='" + id + "']";
        Node node = (Node) xpath.evaluate(expr, doc, XPathConstants.NODE);
        if (node != null) {
            String title = xpath.evaluate("title", node);
            String body = xpath.evaluate("body", node);
%>
<h1><%= title %></h1>
<p><%= body %></p>
<%
        } else {
            out.println("Article not found");
        }
    } catch (Exception e) {
        throw new ServletException(e);
    }
%>

<a href="home.jsp">Back</a>
<script src="../script.js"></script>
</body>
</html>
