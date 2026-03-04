<%@ page session="false" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,javax.xml.parsers.*,javax.xml.xpath.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.*,javax.xml.transform.stream.*,java.io.File" %>

<%
    // Get current session (do not create new one)
    HttpSession ses = request.getSession(false);

    // If user is not logged in, redirect to login page
    if (ses == null || ses.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return;
    }

    // Get logged-in username
    String currentUser = (String) ses.getAttribute("user");

    // Get path to tasks.xml inside WEB-INF
    ServletContext ctx = getServletContext();
    File tasksFile = new File(ctx.getRealPath("/WEB-INF/tasks.xml"));

    // If tasks.xml does not exist, create it with root <tasks>
    if (!tasksFile.exists()) {
        tasksFile.createNewFile();
        
        DocumentBuilderFactory dbfInit = DocumentBuilderFactory.newInstance();
        DocumentBuilder dbInit = dbfInit.newDocumentBuilder();
        Document docInit = dbInit.newDocument();

        // Create root element <tasks>
        Element root = docInit.createElement("tasks");
        docInit.appendChild(root);

        // Save empty XML structure to file
        TransformerFactory tfInit = TransformerFactory.newInstance();
        Transformer trInit = tfInit.newTransformer();
        trInit.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
        trInit.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        trInit.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, "UTF-8");
        trInit.transform(new DOMSource(docInit), new StreamResult(tasksFile));
    }

    // If form is submitted (POST request)
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        // Get form data
        String newName = request.getParameter("name");
        String newDeadline = request.getParameter("deadline");
        String newProgress = request.getParameter("progress");

        if (newName != null && newDeadline != null) {
            try {
                // Load existing tasks.xml
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                DocumentBuilder db = dbf.newDocumentBuilder();
                Document tasksDoc = db.parse(tasksFile);

                // Get all existing tasks to calculate next ID
                XPath xp = XPathFactory.newInstance().newXPath();
                NodeList existing = (NodeList) xp.evaluate("/tasks/task", tasksDoc, XPathConstants.NODESET);

                int maxId = 0;
                for (int i = 0; i < existing.getLength(); i++) {
                    String idStr = xp.evaluate("@id", existing.item(i));
                    maxId = Math.max(maxId, Integer.parseInt(idStr));
                }

                // Create new <task> element
                Element newTask = tasksDoc.createElement("task");
                newTask.setAttribute("id", String.valueOf(maxId + 1));

                // Add task name
                Element t = tasksDoc.createElement("name");
                t.setTextContent(newName);
                newTask.appendChild(t);

                // Add deadline
                Element d = tasksDoc.createElement("deadline");
                d.setTextContent(newDeadline);
                newTask.appendChild(d);

                // Assign task to current logged-in user
                Element a = tasksDoc.createElement("assignee");
                a.setTextContent(currentUser);
                newTask.appendChild(a);

                // Add progress
                Element p = tasksDoc.createElement("progress");
                p.setTextContent(newProgress);
                newTask.appendChild(p);

                // Append new task to root
                tasksDoc.getDocumentElement().appendChild(newTask);

                // Save updated XML back to file
                TransformerFactory tf = TransformerFactory.newInstance();
                Transformer tr = tf.newTransformer();
                tr.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
                tr.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                tr.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING, "UTF-8");
                tr.transform(new DOMSource(tasksDoc), new StreamResult(tasksFile));

                // Reload page after adding task
                response.sendRedirect(request.getContextPath() + "/secure/page2.jsp");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color: red;'>Error adding task</p>");
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
</head>

<body>
<div id="page-wrapper">


<div style="text-align: right;">
    <a href="home.jsp">Back to home</a>
</div>

<h2>My Tasks</h2>


<p>Logged in as: <strong><%= currentUser %></strong></p>


<form method="post">
    <input type="text" name="name" placeholder="Task name" required />
    <input type="date" name="deadline" required />
    <input type="text" name="progress" placeholder="Progress (e.g. 50%)" />
    <button type="submit">Add Task</button>
</form>

<div id="tasks-container">
<%
    try {
        // Load tasks.xml
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.parse(tasksFile);

        // Only show tasks assigned to current user
        XPath xpath = XPathFactory.newInstance().newXPath();
        NodeList tasks = (NodeList) xpath.evaluate("/tasks/task[assignee='" + currentUser + "']", doc, XPathConstants.NODESET);

        if (tasks.getLength() == 0) {
            out.println("<p>No tasks assigned to you.</p>");
        } else {
            // Loop through tasks and display them
            for (int i = 0; i < tasks.getLength(); i++) {
                Node taskNode = tasks.item(i);
                String name = xpath.evaluate("name", taskNode);
                String deadline = xpath.evaluate("deadline", taskNode);
                String progress = xpath.evaluate("progress", taskNode);
%>

    <!-- Display each task -->
    <div class="task-item">
        <strong><%= name %></strong><br/>
        <small>Deadline: <%= deadline %></small><br/>
        <small>Progress: <%= progress %></small>
    </div>

<%
            }
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error loading tasks</p>");
    }
%>
</div>
</div>

<script src="../script.js"></script>
</body>
</html>