<%-- 
    Document   : loginProcess
    Created on : 1/09/2025, 2:00:28?p. m.
    Author     : Mr_Fagua
--%>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if ("docente@gmail.com".equals(email) && "pw1234".equals(password)) {
        session.setAttribute("nombre", "Profesor Demo");
        session.setAttribute("rol", "docente");
        response.sendRedirect("dashboard.jsp");
    } else if ("estudiante@gmail.com".equals(email) && "pw1234".equals(password)) {
        session.setAttribute("nombre", "Estudiante Demo");
        session.setAttribute("rol", "estudiante");
        response.sendRedirect("dashboard.jsp");
    } else {
        // Si falla login
        out.println("<script>alert('Credenciales incorrectas'); window.location='login.jsp';</script>");
    }
%>

