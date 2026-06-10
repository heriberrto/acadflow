<%@page import="java.util.List"%>
<%@page import="modelo.Perfil"%>
<%@page import="modelo.PerfilDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    PerfilDAO dao = new PerfilDAO();
    List<Perfil> perfiles = dao.listarPerfiles();
%>

<div style="font-family: 'Inter', sans-serif; padding: 20px; background: transparent;">
    <h2 style="text-align:center; color:#2563eb;">👥 Gestión de Perfiles</h2>

    <!-- Formulario para agregar perfil -->
    <form class="form-inline" action="${pageContext.request.contextPath}/ControladorPerfil" method="post" style="text-align:center; margin-bottom:20px;">
        <input type="hidden" name="accion" value="registrar">
        <input type="text" name="nombrePerfil" placeholder="Nombre del perfil" required style="padding:8px; margin:4px;">
        <input type="text" name="descripcion" placeholder="Descripción" required style="padding:8px; margin:4px;">
        <button type="submit" class="btn" style="padding:8px 12px; background:#2563eb; color:white; border:none; border-radius:6px;">Agregar</button>
    </form>

    <!-- Tabla de perfiles -->
    <table style="width:100%; border-collapse:collapse; background:white; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.1);">
        <tr style="background:#2563eb; color:white;">
            <th style="padding:10px;">ID</th>
            <th style="padding:10px;">Nombre</th>
            <th style="padding:10px;">Descripción</th>
            <th style="padding:10px;">Acciones</th>
        </tr>

        <% for (Perfil p : perfiles) { %>
        <tr style="text-align:center; border-bottom:1px solid #eee;">
            <td><%= p.getIdPerfil() %></td>
            <td><%= p.getNombrePerfil() %></td>
            <td><%= p.getDescripcion() %></td>
            <td>
                <!-- Editar perfil -->
                <form action="${pageContext.request.contextPath}/ControladorPerfil" method="post" style="display:inline;">
                    <input type="hidden" name="accion" value="editar">
                    <input type="hidden" name="idPerfil" value="<%= p.getIdPerfil() %>">
                    <input type="text" name="nombrePerfil" value="<%= p.getNombrePerfil() %>" required style="padding:5px; margin:4px;">
                    <input type="text" name="descripcion" value="<%= p.getDescripcion() %>" required style="padding:5px; margin:4px;">
                    <button type="submit" class="btn" style="background:#f59e0b; color:white; border:none; border-radius:6px; padding:6px 10px;">Editar</button>
                </form>

                <!-- Eliminar perfil -->
                <form action="${pageContext.request.contextPath}/ControladorPerfil" method="post" style="display:inline;">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="idPerfil" value="<%= p.getIdPerfil() %>">
                    <button type="submit" class="btn" style="background:#dc2626; color:white; border:none; border-radius:6px; padding:6px 10px;">Eliminar</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
