<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.xml.parsers.*,javax.xml.xpath.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.*,javax.xml.transform.stream.*,java.io.File,java.io.FileWriter" %>

<%
    // Get existing session (do not create new one)
    HttpSession ses = request.getSession(false);

    // If user is not logged in, redirect to login page
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    // Get current logged-in username
    String currentUser = (String) ses.getAttribute("user");
    
    // If form is submitted (POST request)
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        // Get form values
        String newTitle = request.getParameter("title");
        String newDesc = request.getParameter("description");
        String newPriority = request.getParameter("priority");
        String newStatus = request.getParameter("status");

        // Debug print
        System.out.println("DEBUG: POST received - title=" + newTitle);

        // Make sure title and description are not null
        if (newTitle != null && newDesc != null) {
            try {
                ServletContext ctx = getServletContext();

                // Load existing todos.xml file
                DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
                DocumentBuilder db2 = dbf2.newDocumentBuilder();
                Document todosDoc = db2.parse(ctx.getResourceAsStream("/WEB-INF/todos.xml"));

                // Use XPath to get all existing todo items
                XPath xp2 = XPathFactory.newInstance().newXPath();
                NodeList existing = (NodeList) xp2.evaluate("/todos/todo", todosDoc, XPathConstants.NODESET);

                // Find highest ID so we can generate next ID
                int maxId = 0;
                for (int i=0;i<existing.getLength();i++) {
                    String idStr = xp2.evaluate("@id", existing.item(i));
                    maxId = Math.max(maxId, Integer.parseInt(idStr));
                }

                // Create new <todo> element
                Element newTodo = todosDoc.createElement("todo");
                newTodo.setAttribute("id", String.valueOf(maxId+1));

                // Add title
                Element t = todosDoc.createElement("title");
                t.setTextContent(newTitle);
                newTodo.appendChild(t);

                // Add description
                Element d = todosDoc.createElement("description");
                d.setTextContent(newDesc);
                newTodo.appendChild(d);

                // Add priority
                Element p = todosDoc.createElement("priority");
                p.setTextContent(newPriority);
                newTodo.appendChild(p);

                // Add status
                Element snew = todosDoc.createElement("status");
                snew.setTextContent(newStatus);
                newTodo.appendChild(snew);

                // Append new todo to root element
                todosDoc.getDocumentElement().appendChild(newTodo);
                
                // Save updated XML back to file
                File todosFile = new File(ctx.getRealPath("/WEB-INF/todos.xml"));
                TransformerFactory tf = TransformerFactory.newInstance();
                Transformer tr = tf.newTransformer();

                // Format XML output
                tr.setOutputProperty("indent", "yes");
                tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                tr.setOutputProperty("encoding", "UTF-8");

                FileWriter fw = new FileWriter(todosFile, false);
                StreamResult result = new StreamResult(fw);

                // Write updated XML
                tr.transform(new DOMSource(todosDoc), result);
                fw.flush();
                fw.close();

                // Reload page after adding todo
                response.sendRedirect(request.getRequestURI());
                return;

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error adding todo</p>");
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<title>Todo List</title>
<link rel="stylesheet" href="../style.css" />
</head>

<body>
<div id="page-wrapper">


<div style="text-align: right;">
    <a href="home.jsp">Back to home</a>
</div>

<h2>My Todo List</h2>


<p>Logged in as: <strong><%= currentUser %></strong></p>


<form method="post">
    <input type="text" name="title" placeholder="Title" required />
    <input type="text" name="description" placeholder="Description" required />
    <select name="priority">
        <option>High</option>
        <option>Medium</option>
        <option>Low</option>
    </select>
    <select name="status">
        <option>In Progress</option>
        <option>Completed</option>
    </select>
    <button type="submit">Add Todo</button>
</form>

<div id="todos-container">
<%
    try {
        ServletContext ctx = getServletContext();

        // Load todos.xml
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(ctx.getResourceAsStream("/WEB-INF/todos.xml"));

        // Use XPath to get all todos
        XPath xpath = XPathFactory.newInstance().newXPath();
        NodeList todos = (NodeList) xpath.evaluate("/todos/todo", doc, XPathConstants.NODESET);

        // Loop through each todo and display it
        for (int i = 0; i < todos.getLength(); i++) {
            Node todoNode = todos.item(i);

            String title = xpath.evaluate("title", todoNode);
            String description = xpath.evaluate("description", todoNode);
            String priority = xpath.evaluate("priority", todoNode);
            String status = xpath.evaluate("status", todoNode);
%>

    <!-- Display each todo item -->
    <div class="todo-item">
        <strong><%= title %></strong>
        <span><%= status %></span>
        <p><%= description %></p>
        <small>Priority: <%= priority %></small>
    </div>

<%
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error loading todos</p>");
    }
%>
</div>
</div>

<script src="../script.js"></script>
</body>
</html>