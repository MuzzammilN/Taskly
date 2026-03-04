<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.xml.parsers.*,javax.xml.xpath.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.*,javax.xml.transform.stream.*,java.io.File" %>
<%
    HttpSession ses = request.getSession(false);
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }
    String currentUser = (String) ses.getAttribute("user");

    ServletContext ctx = getServletContext();
    File tasksFile = new File(ctx.getRealPath("/WEB-INF/tasks.xml"));

    // Ensure the file exists
    if (!tasksFile.exists()) {
        tasksFile.createNewFile();
        // Create root <tasks> element if empty
        DocumentBuilderFactory dbfInit = DocumentBuilderFactory.newInstance();
        DocumentBuilder dbInit = dbfInit.newDocumentBuilder();
        Document docInit = dbInit.newDocument();
        Element root = docInit.createElement("tasks");
        docInit.appendChild(root);

        TransformerFactory tfInit = TransformerFactory.newInstance();
        Transformer trInit = tfInit.newTransformer();
        trInit.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
        trInit.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        trInit.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, "UTF-8");
        trInit.transform(new DOMSource(docInit), new StreamResult(tasksFile));
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newName = request.getParameter("name");
        String newDeadline = request.getParameter("deadline");
        String newProgress = request.getParameter("progress");

        if (newName != null && newDeadline != null) {
            try {
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document tasksDoc = db.parse(tasksFile);

                XPath xp = XPathFactory.newInstance().newXPath();
                NodeList existing = (NodeList) xp.evaluate("/tasks/task", tasksDoc, XPathConstants.NODESET);
                int maxId = 0;
                for (int i = 0; i < existing.getLength(); i++) {
                    String idStr = xp.evaluate("@id", existing.item(i));
                    maxId = Math.max(maxId, Integer.parseInt(idStr));
                }

                Element newTask = tasksDoc.createElement("task");
                newTask.setAttribute("id", String.valueOf(maxId + 1));

                Element t = tasksDoc.createElement("name"); t.setTextContent(newName); newTask.appendChild(t);
                Element d = tasksDoc.createElement("deadline"); d.setTextContent(newDeadline); newTask.appendChild(d);
                Element a = tasksDoc.createElement("assignee"); a.setTextContent(currentUser); newTask.appendChild(a);
                Element p = tasksDoc.createElement("progress"); p.setTextContent(newProgress); newTask.appendChild(p);

                tasksDoc.getDocumentElement().appendChild(newTask);

                TransformerFactory tf = TransformerFactory.newInstance();
                Transformer tr = tf.newTransformer();
                tr.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
                tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                tr.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, "UTF-8");
                tr.transform(new DOMSource(tasksDoc), new StreamResult(tasksFile));

                // Fixed redirect to include context path
                response.sendRedirect(request.getContextPath() + "/secure/page2.jsp");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error adding task: " + e.getMessage() + "</p>");
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
<title>My Tasks</title>
<link rel="stylesheet" href="../style.css" />
<style>
    body { padding: 15px; }
    #page-wrapper { max-width: 800px; margin: 0 auto; }
    .task-item { background-color: white; color: black; border: 1px solid #ddd; padding: 12px; margin: 8px 0; border-radius: 5px; }
    .progress { color: #90ee90; font-weight: bold; }
    .deadline { color: #ff8787; font-size: 0.9rem; }
</style>
</head>
<body>
<div id="page-wrapper">
<div style="text-align: right; margin-bottom: 15px;">
    <a href="home.jsp" style="background-color: #007bff; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px;">Back to home</a>
</div>

<h2>My Tasks</h2>
<p style="color: rgba(255,255,255,0.8); font-size: 0.9rem;">Logged in as: <strong><%= currentUser %></strong></p>

<!-- add task form -->
<form method="post" style="margin-bottom:20px;">
    <input type="text" name="name" placeholder="Task name" required onpaste="return false;" />
    <input type="date" name="deadline" required />
    <input type="text" name="progress" placeholder="Progress (e.g. 50%)" onpaste="return false;" />
    <button type="submit">Add Task</button>
</form>

<div id="tasks-container">
<%
    try {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(tasksFile);

        XPath xpath = XPathFactory.newInstance().newXPath();
        NodeList tasks = (NodeList) xpath.evaluate("/tasks/task[assignee='" + currentUser + "']", doc, XPathConstants.NODESET);

        if (tasks.getLength() == 0) {
            out.println("<p style='color: rgba(255,255,255,0.7);'>No tasks assigned to you.</p>");
        } else {
            for (int i = 0; i < tasks.getLength(); i++) {
                Node taskNode = tasks.item(i);
                String name = xpath.evaluate("name", taskNode);
                String deadline = xpath.evaluate("deadline", taskNode);
                String progress = xpath.evaluate("progress", taskNode);
%>
    <div class="task-item">
        <strong><%= name %></strong><br/>
        <small class="deadline">Deadline: <%= deadline %></small><br/>
        <small>Progress: <span class="progress"><%= progress %></span></small>
    </div>
<%
            }
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error loading tasks: " + e.getMessage() + "</p>");
    }
%>
</div>
</div>
<script src="../script.js"></script>
</body>
</html>