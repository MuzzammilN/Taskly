package com.example.security;

// Import required servlet classes
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// This servlet handles user logout
public class LogoutServlet extends HttpServlet {

    // This method runs when logout is requested (GET request)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current session (do not create a new one)
        HttpSession ses = request.getSession(false);
        
        // If session exists, invalidate it (log the user out)
        if (ses != null) {
            ses.invalidate(); // destroys session data
        }

        // Prevent browser from caching secure pages after logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Redirect user back to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    // If logout is triggered using POST request,
    // call doGet() to perform the same logout logic
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
}