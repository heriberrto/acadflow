<%-- 
    Document   : logout
    Created on : 1/09/2025, 2:05:36 p. m.
    Author     : Mr_Fagua
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Destruye la sesión
    response.sendRedirect("index.jsp"); // Vuelve al inicio
%>

