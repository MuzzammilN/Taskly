package com.example.security;

// Import required servlet classes
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

// This servlet is used to securely display images
public class ImageServlet extends HttpServlet {
    
    // This method runs when someone sends a GET request (like opening an image link)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Get the current session (do not create a new one if it doesn't exist)
        HttpSession ses = req.getSession(false);
        
        // Check if user is logged in (session exists and "user" attribute is set)
        // If not logged in, send 403 Forbidden error
        if (ses == null || ses.getAttribute("user") == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Get the image name from the URL parameter (?name=image.jpg)
        String name = req.getParameter("name");
        
        // If no image name is provided, send 404 Not Found
        if (name == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Get the servlet context (used to access files inside the project)
        ServletContext ctx = getServletContext();
        
        // Try to open the image file from WEB-INF/images folder
        InputStream in = ctx.getResourceAsStream("/WEB-INF/images/" + name);
        
        // If image does not exist, send 404 Not Found
        if (in == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Get the correct file type (like image/jpeg or image/png)
        String mime = ctx.getMimeType(name);
        
        // Set the content type of the response
        // If type is unknown, use default binary type
        resp.setContentType(mime != null ? mime : "application/octet-stream");
        
        // Prevent browser from caching the image
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Get output stream to send image data to browser
        OutputStream out = resp.getOutputStream();
        
        // Create a buffer to read file in small chunks (4KB at a time)
        byte[] buffer = new byte[4096];
        int len;
        
        // Read image file and write it to the response output
        while ((len = in.read(buffer)) != -1) {
            out.write(buffer, 0, len);
        }
        
        // Close input and output streams after done
        in.close();
        out.close();
    }
}