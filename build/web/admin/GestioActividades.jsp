<%@page import="java.util.List"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page import="modelo.Perfil"%>
<%@page import="modelo.PerfilDAO"%>
<%@page import="modelo.Actividad"%>
<%@page import="modelo.ActividadDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    ActividadDAO dao = new ActividadDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    PerfilDAO perfilDAO = new PerfilDAO();
    List<Actividad> actividades = dao.listarActividades();
    List<Usuario> usuarios = usuarioDAO.listarUsuarios();
    List<Perfil> perfiles = perfilDAO.listarPerfiles();
%>

<div style="font-family: 'Inter', sans-serif; padding: 20px; background: transparent;">
    <h2 style="text-align:center; color:#2563eb;">⚙️ Gestión de Actividades</h2>

    <!-- Formulario para registrar nueva actividad -->
    <form class="form-inline" action="${pageContext.request.contextPath}/ControladorActividad" method="post" style="text-align:center; margin-bottom:20px;">
        <input type="hidden" name="accion" value="registrar">
        <input type="text" name="nombre" placeholder="Nombre de la actividad" required style="padding:8px; margin:4px; border-radius:6px; border:1px solid #ccc;">
        <input type="text" name="enlace" placeholder="Enlace (dashboard.jsp?page=...)" required style="padding:8px; margin:4px; border-radius:6px; border:1px solid #ccc;">
        <input type="text" name="icono" placeholder="Icono FontAwesome" style="padding:8px; margin:4px; border-radius:6px; border:1px solid #ccc;">
        <button type="submit" class="btn" style="padding:8px 12px; background:#2563eb; color:white; border:none; border-radius:6px;">Agregar</button>
    </form>

    <!-- Tabla de actividades -->
    <table style="width:100%; border-collapse:collapse; background:white; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.1);">
        <tr style="background:#2563eb; color:white;">
            <th style="padding:10px;">ID</th>
            <th style="padding:10px;">Actividad</th>
            <th style="padding:10px;">Enlace</th>
            <th style="padding:10px;">Icono</th>
            <th style="padding:10px;">Asignar Rol</th>
            <th style="padding:10px;">Asignar Usuario</th>
            <th style="padding:10px;">Acciones</th>
        </tr>

        <% for (Actividad a : actividades) { %>
        <tr style="text-align:center; border-bottom:1px solid #eee;">
            <td><%= a.getId() %></td>
            <td><%= a.getNombreActividad() %></td>
            <td><%= a.getEnlace() %></td>
            <td><i class="<%= a.getIcono() %>"></i></td>

            <!-- Asignar Rol -->
            <td>
                <form action="${pageContext.request.contextPath}/ControladorActividad" method="post">
                    <input type="hidden" name="idActividad" value="<%= a.getId() %>">
                    <select name="idPerfil" id="rol_<%= a.getId() %>" onchange="actualizarBotonRol(<%= a.getId() %>)" required
                            style="padding:6px; border:1px solid #ccc; border-radius:6px;">
                        <option value="">-- Seleccionar rol --</option>
                        <% for (Perfil p : perfiles) {
                            boolean asignada = dao.tieneActividadAsignadaARol(a.getId(), p.getIdPerfil());
                        %>
                        <option value="<%= p.getIdPerfil() %>" data-asignada="<%= asignada %>">
                            <%= p.getNombrePerfil() %> <%= asignada ? "(Asignada)" : "" %>
                        </option>
                        <% } %>
                    </select>
                    <input type="hidden" name="accion" id="accionRol_<%= a.getId() %>" value="asignarRol">
                    <button type="submit" id="btnRol_<%= a.getId() %>" class="btn"
                            style="padding:6px 10px; background:#2563eb; color:white; border:none; border-radius:6px;">Guardar</button>
                </form>
            </td>

            <!-- Asignar Usuario -->
            <td>
                <form action="${pageContext.request.contextPath}/ControladorActividad" method="post">
                    <input type="hidden" name="idActividad" value="<%= a.getId() %>">
                    <select name="idUsuario" id="usuario_<%= a.getId() %>" onchange="actualizarBotonUsuario(<%= a.getId() %>)" required
                            style="padding:6px; border:1px solid #ccc; border-radius:6px;">
                        <option value="">-- Seleccionar usuario --</option>
                        <% for (Usuario u : usuarios) {
                            boolean asignadaU = dao.tieneActividadAsignadaAUsuario(a.getId(), u.getId());
                        %>
                        <option value="<%= u.getId() %>" data-asignada="<%= asignadaU %>">
                            <%= u.getNombres() %> <%= asignadaU ? "(Asignada)" : "" %>
                        </option>
                        <% } %>
                    </select>
                    <input type="hidden" name="accion" id="accionUsuario_<%= a.getId() %>" value="asignarUsuario">
                    <button type="submit" id="btnUsuario_<%= a.getId() %>" class="btn"
                            style="padding:6px 10px; background:#2563eb; color:white; border:none; border-radius:6px;">Guardar</button>
                </form>
            </td>

            <!-- Eliminar actividad -->
            <td>
                <form action="${pageContext.request.contextPath}/ControladorActividad" method="post"
                      onsubmit="return confirm('¿Desea eliminar esta actividad?');" style="display:inline;">
                    <input type="hidden" name="idActividad" value="<%= a.getId() %>">
                    <input type="hidden" name="accion" value="eliminar">
                    <button type="submit" class="btn" style="background:#dc2626; color:white; border:none; border-radius:6px; padding:6px 10px;">Eliminar</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>

<script>
    function actualizarBotonRol(idActividad) {
        const select = document.getElementById('rol_' + idActividad);
        const boton = document.getElementById('btnRol_' + idActividad);
        const accion = document.getElementById('accionRol_' + idActividad);
        const seleccion = select.options[select.selectedIndex];
        if (seleccion && seleccion.dataset.asignada === "true") {
            boton.textContent = "Revocar";
            boton.style.background = "#f59e0b";
            accion.value = "revocarRol";
        } else {
            boton.textContent = "Guardar";
            boton.style.background = "#2563eb";
            accion.value = "asignarRol";
        }
    }

    function actualizarBotonUsuario(idActividad) {
        const select = document.getElementById('usuario_' + idActividad);
        const boton = document.getElementById('btnUsuario_' + idActividad);
        const accion = document.getElementById('accionUsuario_' + idActividad);
        const seleccion = select.options[select.selectedIndex];
        if (seleccion && seleccion.dataset.asignada === "true") {
            boton.textContent = "Revocar";
            boton.style.background = "#f59e0b";
            accion.value = "revocarUsuario";
        } else {
            boton.textContent = "Guardar";
            boton.style.background = "#2563eb";
            accion.value = "asignarUsuario";
        }
    }
</script>
