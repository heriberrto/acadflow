<%@ page contentType="text/html" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Actividad" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String rol = (String) session.getAttribute("rol");
    String nombre = (String) session.getAttribute("nombre");
    String email = (String)   session.getAttribute("correo");

    if (rol == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String currentPage = request.getParameter("page");
    if (currentPage == null)
        currentPage = "";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard | AcadFlow</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f5f6fa;
                display: flex;
                flex-direction: column;
                height: 100vh;
            }
            header {
                background: #4a90e2;
                color: black;
                padding: 1rem 2rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
            }
            header h1 {
                margin: 0;
                cursor: pointer;
            }
            .profile-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: white;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                color: #4a90e2;
                font-weight: bold;
            }
            .profile-card {
                position: absolute;
                top: 70px;
                right: 20px;
                background: white;
                padding: 1rem;
                border-radius: 10px;
                box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
                display: none;
                flex-direction: column;
                gap: 0.5rem;
                min-width: 180px;
            }
            .profile-card.show {
                display: flex;
            }
            .logout-btn {
                background: #e74c3c;
                color: white;
                padding: 0.5rem;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .layout {
                display: flex;
                margin-top: 70px;
                height: calc(100vh - 70px);
            }
            .sidebar {
                width: 220px;
                background: #2c3e50;
                color: white;
                padding: 1rem;
                flex-shrink: 0;
            }
            .sidebar h2 {
                font-size: 1.1rem;
                margin-bottom: 1rem;
            }
            .sidebar ul {
                list-style: none;
                padding: 0;
            }
            .sidebar ul li {
                margin-bottom: 0.8rem;
            }
            .sidebar ul li a {
                color: white;
                text-decoration: none;
                padding: 0.5rem;
                display: block;
                border-radius: 5px;
                transition: background 0.3s;
            }
            .sidebar ul li a:hover {
                background: #34495e;
            }
            .content {
                flex: 1;
                padding: 2rem;
                overflow-y: auto;
            }
            .card {
                background: white;
                padding: 1rem;
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0,0,0,0.05);
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>
        <header>
            <h1 onclick="window.location.href = 'index.jsp'">AcadFlow</h1>

            <div class="profile">
                <div class="profile-icon" onclick="toggleProfile()">
                    <img src="https://img.icons8.com/?size=100&id=DTdiAnVTTHBo&format=png&color=000000" width="40" height="40">
                </div>
                <div class="profile-card" id="profileCard">
                    <p><strong>
                            <%=email + "<br>" + rol %>
                        </strong></p>
                    <form action="logout.jsp" method="post">
                        <button type="submit" class="logout-btn">Cerrar Sesión</button>
                    </form>
                </div>
            </div>
        </header>

        <div class="layout">
            <!-- Sidebar -->
            <aside class="sidebar">
                <h2>Menú</h2>
                <ul>
                    <%
                        List<Actividad> actividades = (List<Actividad>) session.getAttribute("actividades");
                        if (actividades != null && !actividades.isEmpty()) {
                            for (Actividad act : actividades) {
                                String enlace = act.getEnlace();
                                // Enlace corregido: quitar "dashboard.jsp?page=" si ya viene incluido
                                if (!enlace.startsWith("dashboard.jsp?page=")) {
                                    enlace = "dashboard.jsp?page=" + enlace;
                                }
                    %>
                    <li>
                        <a href="<%= enlace%>">
                            <i class="<%= act.getIcono()%>"></i> <%= act.getNombreActividad()%>
                        </a>
                    </li>
                    <%
                        }
                    } else {
                    %>
                    <li><em>No tienes actividades asignadas.</em></li>
                        <% } %>
                </ul>
            </aside>

            <!-- Contenido dinámico -->
            <main class="content">
                <%

                    if (currentPage != null && !currentPage.isEmpty()) {
                        try {
                            if (currentPage.startsWith("Controlador")) {
                                // Si el parámetro apunta a un servlet, redirigimos
                                response.sendRedirect(currentPage);
                            } else {
                                // Si es una página JSP, la incluimos normalmente
                                if (!currentPage.endsWith(".jsp")) {
                                    currentPage += ".jsp";
                                }
                %>
                <jsp:include page="<%= currentPage%>" />
                <%
                    }
                } catch (Exception e) {
                %>
                <div class="card">
                    <h2>Error al cargar la página</h2>
                    <p>No se pudo cargar la ruta: <%= currentPage%></p>
                </div>
                <%
                    }
                } else {
                %>
                <div class="card">
                    <h2>Bienvenido <%= rol.substring(0, 1).toUpperCase() + rol.substring(1)%></h2>
                    <p>Selecciona una opción del menú lateral.</p>
                </div>
                <%
                    }

                %>
            </main>

        </div>

        <script>
            function toggleProfile() {
                document.getElementById("profileCard").classList.toggle("show");
            }
        </script>
    </body>
</html>
