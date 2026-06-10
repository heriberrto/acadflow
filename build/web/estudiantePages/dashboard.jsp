<%@page import="java.util.List"%>
<%@page import="modelo.Tarea"%>
<%@page import="modelo.Proyectos"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Tarea> misTareas = (List<Tarea>) request.getAttribute("misTareas");
    List<Proyectos> misProyectos = (List<Proyectos>) request.getAttribute("misProyectos");

    int totalTareas = misTareas != null ? misTareas.size() : 0;
    int completadas = 0;
    int enProgreso = 0;
    int enRevision = 0;
    int pendientes = 0;

    if (misTareas != null) {
        for (Tarea t : misTareas) {
            switch(t.getEstado().toLowerCase()) {
                case "completada": completadas++; break;
                case "en progreso": enProgreso++; break;
                case "en revisión": enRevision++; break;
                case "pendiente": pendientes++; break;
            }
        }
    }

    int avanceGeneral = totalTareas > 0 ? (completadas * 100) / totalTareas : 0;
%>

<div style="font-family:'Inter',sans-serif;padding:20px;background:#f8fafc;min-height:100vh;">
    <h2 style="text-align:center;color:#1e40af;font-weight:600;margin-bottom:30px;">Dashboard</h2>

    <!-- Resumen de Tareas -->
    <div style="display:flex; gap:20px; flex-wrap:wrap; margin-bottom:30px;">
        <div style="flex:1; min-width:200px; background:white; border-radius:8px; padding:20px; box-shadow:0 2px 6px rgba(0,0,0,0.08); text-align:center;">
            <h3 style="color:#ef4444;">Pendientes</h3>
            <p style="font-size:24px;font-weight:600;"><%= pendientes %></p>
        </div>
        <div style="flex:1; min-width:200px; background:white; border-radius:8px; padding:20px; box-shadow:0 2px 6px rgba(0,0,0,0.08); text-align:center;">
            <h3 style="color:#3b82f6;">En Progreso</h3>
            <p style="font-size:24px;font-weight:600;"><%= enProgreso %></p>
        </div>
        <div style="flex:1; min-width:200px; background:white; border-radius:8px; padding:20px; box-shadow:0 2px 6px rgba(0,0,0,0.08); text-align:center;">
            <h3 style="color:#facc15;">En Revisión</h3>
            <p style="font-size:24px;font-weight:600;"><%= enRevision %></p>
        </div>
        <div style="flex:1; min-width:200px; background:white; border-radius:8px; padding:20px; box-shadow:0 2px 6px rgba(0,0,0,0.08); text-align:center;">
            <h3 style="color:#22c55e;">Completadas</h3>
            <p style="font-size:24px;font-weight:600;"><%= completadas %></p>
        </div>
    </div>

    <!-- Avance general -->
    <div style="background:white; padding:20px; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.08); margin-bottom:30px;">
        <h3 style="color:#1e40af;margin-bottom:10px;">Avance General</h3>
        <div style="background:#e5e7eb; border-radius:8px; height:20px; overflow:hidden;">
            <div style="width:<%= avanceGeneral %>%; height:100%; background:#22c55e; transition:width 0.3s;"></div>
        </div>
        <p style="margin-top:5px; font-size:14px; color:#374151;"><%= avanceGeneral %>% completadas de <%= totalTareas %> tareas</p>
    </div>

    <!-- Lista de proyectos -->
    <div style="background:white; padding:20px; border-radius:8px; box-shadow:0 2px 6px rgba(0,0,0,0.08);">
        <h3 style="color:#1e40af; margin-bottom:15px;">Proyectos Asignados</h3>
        <table style="width:100%; border-collapse:collapse;">
            <thead>
                <tr style="background:#2563eb; color:white; text-align:center;">
                    <th style="padding:10px;">ID</th>
                    <th style="padding:10px;">Nombre</th>
                    <th style="padding:10px;">Avance</th>
                    <th style="padding:10px;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% if (misProyectos != null && !misProyectos.isEmpty()) {
                    for (Proyectos p : misProyectos) {
                        int tareasProyecto = p.getTotalTareas(); // asumir método que cuenta tareas
                        int completadasProyecto = p.getTareasCompletadas(); // método que devuelve tareas completadas
                        int avanceProyecto = tareasProyecto > 0 ? (completadasProyecto * 100) / tareasProyecto : 0;
                        String colorBarra = avanceProyecto >= 71 ? "#22c55e" : (avanceProyecto >= 31 ? "#facc15" : "#ef4444");
                %>
                <tr style="text-align:center; border-bottom:1px solid #e5e7eb;">
                    <td><%= p.getIdProyecto() %></td>
                    <td style="text-align:left; padding-left:8px;"><%= p.getNombreProyecto() %></td>
                    <td>
                        <div style="background:#e5e7eb; border-radius:8px; height:14px; overflow:hidden;">
                            <div style="width:<%= avanceProyecto %>%; height:100%; background:<%= colorBarra %>; transition: width 0.3s;"></div>
                        </div>
                        <span style="font-size:12px; color:#374151;"><%= avanceProyecto %>%</span>
                    </td>
                    <td>
                        <form action="ControladorTareas" method="get" style="display:inline;">
                            <input type="hidden" name="accion" value="listarTareasPorProyecto">
                            <input type="hidden" name="idProyecto" value="<%= p.getIdProyecto() %>">
                            <button type="submit" style="background:#2563eb; color:white; border:none; padding:6px 12px; border-radius:6px; cursor:pointer;">
                                Ver tareas
                            </button>
                        </form>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="4" style="text-align:center; padding:10px; color:#6b7280;">No tienes proyectos asignados.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
