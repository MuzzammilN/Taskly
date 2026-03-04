package com.example.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class ImageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession ses = req.getSession(false);
        if (ses == null || ses.getAttribute("user") == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String name = req.getParameter("name");
        if (name == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        ServletContext ctx = getServletContext();
        InputStream in = ctx.getResourceAsStream("/WEB-INF/images/" + name);
        if (in == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String mime = ctx.getMimeType(name);
        resp.setContentType(mime != null ? mime : "application/octet-stream");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        OutputStream out = resp.getOutputStream();
        byte[] buffer = new byte[4096];
        int len;
        while ((len = in.read(buffer)) != -1) {
            out.write(buffer, 0, len);
        }
        in.close();
        out.close();
    }
}