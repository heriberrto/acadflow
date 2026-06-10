<%@ page import="java.util.List" %>
<%@ page import="modelo.Equipo" %>
<%@ page import="modelo.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Equipo> equipos = (List<Equipo>) request.getAttribute("equipos");
    String rol = (String) session.getAttribute("rol");
    int idUsuarioSesion = (int) session.getAttribute("id");
    
%>



<div style="font-family:'Inter',sans-serif;padding:20px;background:#f8fafc;min-height:100vh;">

    <h2 style="text-align:center;color:#1e40af;font-weight:600;margin-bottom:30px;">
        Gestión de Equipos
    </h2>

    <!-- Botón crear nuevo equipo (solo docentes o admin) -->
    <% if ("docente".equalsIgnoreCase(rol) || "admin".equalsIgnoreCase(rol)) { %>
    <div style="text-align:right;margin-bottom:20px;">
        <button onclick="document.getElementById('modalCrearEquipo').style.display = 'block'"
                style="background:#1e40af;color:white;border:none;padding:10px 18px;border-radius:6px;font-weight:500;cursor:pointer;">
            + Nuevo Equipo
        </button>
    </div>
    <% } %>

    <div style="background:white;border-radius:10px;padding:20px;box-shadow:0 2px 10px rgba(0,0,0,0.08);">
        <table style="width:100%;border-collapse:collapse;text-align:left;">
            <thead>
                <tr style="background:#e5e7eb;color:#1f2937;">
                    <th style="padding:10px;border-bottom:2px solid #d1d5db;">ID</th>
                    <th style="padding:10px;border-bottom:2px solid #d1d5db;">Nombre del Equipo</th>
                    <th style="padding:10px;border-bottom:2px solid #d1d5db;">Docente Responsable</th>
                    <th style="padding:10px;border-bottom:2px solid #d1d5db;text-align:center;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% if (equipos != null && !equipos.isEmpty()) {
                        for (Equipo e : equipos) {%>
                <tr style="border-bottom:1px solid #f3f4f6;">
                    <td style="padding:10px;"><%= e.getIdEquipo()%></td>
                    <td style="padding:10px;font-weight:500;"><%= e.getNombreEquipo()%></td>
                    <td style="padding:10px;"><%= e.getNombreDocente() != null ? e.getNombreDocente() : "Sin asignar"%></td>

                    <td style="padding:10px;text-align:center;">
                        <!-- Ver Integrantes -->
                        <form method="get" action="ControladorEquipo" style="display:inline;">
                            <input type="hidden" name="accion" value="verIntegrantes">
                            <input type="hidden" name="idEquipo" value="<%= e.getIdEquipo()%>">
                            <button type="submit"
                                    style="background:#3b82f6;color:white;border:none;padding:6px 12px;border-radius:4px;font-size:13px;cursor:pointer;">
                                Ver Integrantes
                            </button>
                        </form>

                        <% if ("admin".equalsIgnoreCase(rol) || ("docente".equalsIgnoreCase(rol) && e.getIdDocente() == idUsuarioSesion)) {%>
                        <!-- Eliminar equipo -->
                        <form method="post" action="ControladorEquipo" style="display:inline;">
                            <input type="hidden" name="accion" value="eliminar">
                            <input type="hidden" name="idEquipo" value="<%= e.getIdEquipo()%>">
                            <button type="submit"
                                    style="background:#dc2626;color:white;border:none;padding:6px 12px;border-radius:4px;font-size:13px;cursor:pointer;margin-left:5px;">
                                Eliminar
                            </button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="4" style="padding:15px;text-align:center;color:#6b7280;">
                        No hay equipos registrados.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Crear Equipo -->
<div id="modalCrearEquipo"
     style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.4);z-index:100;">
    <div style="background:white;width:400px;margin:100px auto;padding:25px;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,0.15);">
        <h3 style="color:#1e40af;text-align:center;margin-bottom:15px;">Crear Nuevo Equipo</h3>

        <form method="post" action="ControladorEquipo">
            <input type="hidden" name="accion" value="registrar">

            <label style="font-size:14px;color:#374151;">Nombre del equipo</label>
            <input type="text" name="nombreEquipo" required
                   style="width:100%;margin-bottom:10px;padding:8px;border:1px solid #d1d5db;border-radius:6px;">

            <% if ("admin".equalsIgnoreCase(rol)) { %>
            <label style="font-size:14px;color:#374151;">Docente Responsable</label>
            <select name="idDocente"
                    style="width:100%;margin-bottom:15px;padding:8px;border:1px solid #d1d5db;border-radius:6px;">
                <option value="">Seleccione un docente...</option>
                <%
                    List<Usuario> docentes = (List<Usuario>) request.getAttribute("docentes");
                    if (docentes != null) {
                        for (Usuario d : docentes) {
                %>
                <option value="<%= d.getId()%>"><%= d.getNombres()%> <%= d.getApellidos()%></option>
                <%
                        }
                    }
                %>
            </select>

            <% } else {%>
            <input type="hidden" name="idDocente" value="<%= idUsuarioSesion%>">
            <% }%>

            <div style="text-align:center;">
                <button type="submit"
                        style="background:#1e40af;color:white;padding:8px 15px;border:none;border-radius:6px;margin-right:5px;cursor:pointer;">
                    Crear
                </button>
                <button type="button" onclick="document.getElementById('modalCrearEquipo').style.display = 'none'"
                        style="background:#6b7280;color:white;padding:8px 15px;border:none;border-radius:6px;cursor:pointer;">
                    Cancelar
                </button>
            </div>
        </form>
    </div>
</div>
            
            
<%
String mensaje = request.getParameter("mensaje");
if ("ok".equals(mensaje)) {
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
Swal.fire({
  title: '✅ Éxito',
  text: 'Equipo registrado correctamente.',
  icon: 'success',
  confirmButtonText: 'Aceptar',
  timer: 2000,
  timerProgressBar: true
});
</script>
<%
} else if ("error".equals(mensaje)) {
%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
Swal.fire({
  title: '❌ Error',
  text: 'No se pudo registrar el equipo.',
  icon: 'error',
  confirmButtonText: 'Intentar de nuevo'
});
</script>
<%
}
%>


