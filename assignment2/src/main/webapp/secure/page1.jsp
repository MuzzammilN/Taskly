<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.xml.parsers.*,javax.xml.xpath.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.*,javax.xml.transform.stream.*,java.io.File,java.io.FileWriter" %>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
    String currentUser = (String) ses.getAttribute("user");
    
  
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newTitle = request.getParameter("title");
        String newDesc = request.getParameter("description");
        String newPriority = request.getParameter("priority");
        String newStatus = request.getParameter("status");
        System.out.println("DEBUG: POST received - title=" + newTitle + ", desc=" + newDesc + ", priority=" + newPriority + ", status=" + newStatus);
        if (newTitle != null && newDesc != null) {
            try {
                ServletContext ctx = getServletContext();
                DocumentBuilderFactory dbf2 = DocumentBuilderFactory.newInstance();
                DocumentBuilder db2 = dbf2.newDocumentBuilder();
                Document todosDoc = db2.parse(ctx.getResourceAsStream("/WEB-INF/todos.xml"));
                XPath xp2 = XPathFactory.newInstance().newXPath();
                NodeList existing = (NodeList) xp2.evaluate("/todos/todo", todosDoc, XPathConstants.NODESET);
                int maxId = 0;
                for (int i=0;i<existing.getLength();i++) {
                    String idStr = xp2.evaluate("@id", existing.item(i));
                    maxId = Math.max(maxId, Integer.parseInt(idStr));
                }
                Element newTodo = todosDoc.createElement("todo");
                newTodo.setAttribute("id", String.valueOf(maxId+1));
                Element t = todosDoc.createElement("title"); t.setTextContent(newTitle); newTodo.appendChild(t);
                Element d = todosDoc.createElement("description"); d.setTextContent(newDesc); newTodo.appendChild(d);
                Element p = todosDoc.createElement("priority"); p.setTextContent(newPriority); newTodo.appendChild(p);
                Element snew = todosDoc.createElement("status"); snew.setTextContent(newStatus); newTodo.appendChild(snew);
                todosDoc.getDocumentElement().appendChild(newTodo);
                
                File todosFile = new File(ctx.getRealPath("/WEB-INF/todos.xml"));
                TransformerFactory tf = TransformerFactory.newInstance();
                Transformer tr = tf.newTransformer();
                tr.setOutputProperty("indent", "yes");
                tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                tr.setOutputProperty("encoding", "UTF-8");
                
                
                FileWriter fw = new FileWriter(todosFile, false);
                StreamResult result = new StreamResult(fw);
                tr.transform(new DOMSource(todosDoc), result);
                fw.flush();
                fw.close();
                
                System.out.println("DEBUG: XML written to " + todosFile.getAbsolutePath() + " - File exists: " + todosFile.exists() + " - Size: " + todosFile.length());
                response.sendRedirect(request.getRequestURI());
                return;
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error adding todo: " + e.getMessage() + "</p>");
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
<style>
    body { padding: 15px; }
    #page-wrapper { max-width: 800px; margin: 0 auto; }
    .todo-item { background-color: white; color: black; border: 1px solid #ddd; padding: 12px; margin: 8px 0; border-radius: 5px; }
    .status { display: inline-block; padding: 4px 8px; border-radius: 3px; font-size: 0.9rem; margin-left: 10px; }
    .Completed { background-color: #51cf66; color: black; }
    .In\ Progress { background-color: #ffd43b; color: black; }
    .priority { font-weight: bold; color: #ff8787; }
    select { color: black; }
</style>
</head>
<body>
<div id="page-wrapper">
<div style="text-align: right; margin-bottom: 15px;"><a href="home.jsp" style="background-color: #007bff; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px;">Back to home</a></div>
<%
    
    out.println("<!-- DEBUG: Request Method = " + request.getMethod() + " -->");
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        out.println("<!-- DEBUG: POST parameters received -->");
        String newTitle = request.getParameter("title");
        String newDesc = request.getParameter("description");
        if (newTitle != null) {
            out.println("<div style='background-color: lightblue; padding: 10px; margin: 10px 0; border-radius: 5px;'>");
            out.println("<strong>DEBUG - Form received:</strong> title=" + newTitle + ", description=" + newDesc);
            out.println("</div>");
        }
    }
%>
<h2>My Todo List</h2>
<p style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Logged in as: <strong><%= currentUser %></strong></p>

<form method="post" style="margin-bottom:20px;">
    <input type="text" name="title" placeholder="Title" required  onpaste="return false;" />
    <input type="text" name="description" placeholder="Description" required onpaste="return false;" />
    <select name="priority">
        <option>High</option><option>Medium</option><option>Low</option>
    </select>
    <select name="status">
        <option>In Progress</option><option>Completed</option>
    </select>
    <button type="submit">Add Todo</button>
</form>
<div id="todos-container">
<%
    ServletContext ctx = getServletContext();
    try {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(ctx.getResourceAsStream("/WEB-INF/todos.xml"));
        XPath xpath = XPathFactory.newInstance().newXPath();
        NodeList todos = (NodeList) xpath.evaluate("/todos/todo", doc, XPathConstants.NODESET);
        
        for (int i = 0; i < todos.getLength(); i++) {
            Node todoNode = todos.item(i);
            String id = xpath.evaluate("@id", todoNode);
            String title = xpath.evaluate("title", todoNode);
            String description = xpath.evaluate("description", todoNode);
            String priority = xpath.evaluate("priority", todoNode);
            String status = xpath.evaluate("status", todoNode);
%>
    <div class="todo-item">
        <strong><%= title %></strong>
        <span class="status <%= status.replace(" ", "") %>"><%= status %></span>
        <br/>
        <p style="margin: 8px 0 0 0;"><%= description %></p>
        <small>Priority: <span class="priority"><%= priority %></span></small>
    </div>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error loading todos: " + e.getMessage() + "</p>");
    }
%>
</div>
</div>
<script src="../script.js"></script>
</body>
</html>