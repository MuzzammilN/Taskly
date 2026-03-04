package com.example.security;

// Import required servlet classes
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;

// Import XML parsing libraries
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

// This servlet handles user login
public class LoginServlet extends HttpServlet {

    // This method runs when the login form is submitted (POST request)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get username and password from the login form
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");
        
        // Variable to check if login is valid
        boolean valid = false;

        // Get path of users.xml file inside WEB-INF
        ServletContext ctx = getServletContext();
        String path = ctx.getRealPath("/WEB-INF/users.xml");

        try {
            // Create XML document builder
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            
            // Enable validation (checks XML against DTD if exists)
            dbf.setValidating(true);
            
            DocumentBuilder db = dbf.newDocumentBuilder();
            
            // Parse the XML file
            Document doc = db.parse(new File(path));
            
            // Get all <user> elements
            NodeList list = doc.getElementsByTagName("user");

            // Loop through all users in XML
            for (int i = 0; i < list.getLength(); i++) {
                Element user = (Element) list.item(i);

                // Check if username and password match
                if (user.getAttribute("id").equals(uname)
                        && user.getAttribute("password").equals(pass)) {
                    valid = true;  // Login is correct
                    break;
                }
            }
        } catch (Exception e) {
            // If error happens, throw servlet exception
            throw new ServletException(e);
        }

        // If login is valid
        if (valid) {
            
            // Create a new session
            HttpSession session = request.getSession(true);
            
            // Store username in session
            session.setAttribute("user", uname);
            
            // Set session timeout to 5 minutes
            session.setMaxInactiveInterval(5 * 60); // five minutes
            
            // Redirect to secure home page
            response.sendRedirect(request.getContextPath() + "/secure/home.jsp");
        } else {
            
            // If login is invalid, show error message
            request.setAttribute("error", "Invalid username or password");
            
            // Forward back to login page
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    // If someone tries to access LoginServlet directly with GET request
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Redirect them to login page
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}