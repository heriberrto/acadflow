<%@ page import="java.util.List"%>
<%@ page import="modelo.Tarea"%>
<%@ page import="java.util.stream.Collectors"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<Tarea> misTareas = (List<Tarea>) request.getAttribute("misTareas");

    // Total de tareas y tareas completadas
    int totalTareas = misTareas != null ? misTareas.size() : 0;
    int tareasCompletadas = 0;
    if (misTareas != null) {
        tareasCompletadas = (int) misTareas.stream()
                .filter(t -> "completada".equalsIgnoreCase(t.getEstado()))
                .count();
    }

    int porcentajeAvance = totalTareas > 0 ? (tareasCompletadas * 100) / totalTareas : 0;

    String colorBarra = "#ef4444"; // rojo
    if (porcentajeAvance >= 71) {
        colorBarra = "#22c55e"; // verde
    } else if (porcentajeAvance >= 31) {
        colorBarra = "#facc15"; // amarillo
    }%>

<div style="font-family:'Inter',sans-serif;padding:20px;background:#f8fafc;min-height:100vh;">
    <h2 style="text-align:center;color:#1e40af;font-weight:600;margin-bottom:30px;">
        Mis Tareas
    </h2>

    <!-- Barra general de progreso -->
    <div style="background:white;border-radius:8px;padding:20px;margin-bottom:30px;box-shadow:0 2px 6px rgba(0,0,0,0.08);">
        <h3 style="margin:0 0 10px 0;font-weight:600;color:#111827;">Progreso total</h3>
        <div style="background:#e5e7eb;border-radius:8px;height:20px;width:100%;overflow:hidden;">
            <div style="width:<%= porcentajeAvance%>%;height:100%;background:<%= colorBarra%>;transition:width 0.3s;"></div>
        </div>
        <span style="font-size:14px;color:#374151;font-weight:500;"><%= porcentajeAvance%>% completadas (<%= tareasCompletadas%> de <%= totalTareas%>)</span>
    </div>

    <!-- Tareas por estado -->
    <div style="display:flex;justify-content:space-between;gap:20px;flex-wrap:wrap;">
        <% String[] estados = {"pendiente", "en progreso", "en revisión", "completada"}; %>
        <% String[] colores = {"#ef4444", "#3b82f6", "#facc15", "#22c55e"}; %>

        <% for (int i = 0; i < estados.length; i++) {
                final int index = i;  // <-- variable final para usar dentro del lambda
        %>
        <div style="flex:1; min-width:250px; background:white; border-radius:8px; padding:15px; box-shadow:0 2px 6px rgba(0,0,0,0.08);">
            <h3 style="color:<%=colores[i]%>;text-align:center;font-weight:600;text-transform:uppercase;font-size:14px;letter-spacing:0.5px;">
                <%= estados[i].replace("_", " ")%>
            </h3>
            <hr style="border:none;border-top:1px solid #e5e7eb;margin:10px 0;">

            <%
                List<Tarea> tareasEstado = misTareas.stream()
                        .filter(t -> t.getEstado().equalsIgnoreCase(estados[index]))
                        .collect(Collectors.toList());
                for (Tarea t : tareasEstado) {
            %>
            <a href="ControladorTareas?accion=listarTareasPorProyecto&idProyecto=<%=t.getIdProyecto()%>" style="text-decoration:none;">
                <div style="background:white;border-left:4px solid <%=colores[i]%>;border-radius:6px;padding:12px;margin:10px 0;box-shadow:0 1px 4px rgba(0,0,0,0.08);cursor:pointer;">
                    <h4 style="margin:0;font-size:15px;font-weight:600;color:#111827;">
                        <%= t.getTitulo()%>
                    </h4>
                    <p style="margin:5px 0;font-size:13px;color:#6b7280;">
                        Proyecto: <strong><%= t.getNombreProyecto()%></strong>
                    </p>
                    <p style="margin:5px 0;font-size:14px;color:#4b5563;"><%= t.getDescripcion()%></p>
                </div>
            </a>
            <% } %>
        </div>
        <% }%>

    </div>
</div>
