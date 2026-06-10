<%@page import="java.sql.Date"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="modelo.Proyectos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Proyectos> misProyectos = (List<Proyectos>) request.getAttribute("misProyectos");
    Map<Integer, Integer> totalTareasPorProyecto = (Map<Integer, Integer>) request.getAttribute("totalTareasPorProyecto");
    Map<Integer, Integer> tareasCompletadasPorProyecto = (Map<Integer, Integer>) request.getAttribute("tareasCompletadasPorProyecto");
    LocalDate hoy = LocalDate.now();
%>

<div style="font-family: 'Inter', sans-serif; padding: 20px;">
    <h2 style="text-align:center; color:#2563eb; margin-bottom:20px;">Mis Proyectos</h2>

    <table style="width:100%; border-collapse:collapse; background:white; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
        <thead>
            <tr style="background:#2563eb; color:white; text-align:center;">
                <th style="padding:10px; width:5%;">Estado</th>
                <th style="padding:10px;">ID</th>
                <th style="padding:10px;">Nombre</th>
                <th style="padding:10px;">Descripción</th>
                <th style="padding:10px;">Inicio</th>
                <th style="padding:10px;">Final</th>
                <th style="padding:10px;">Avance</th>
                <th style="padding:10px;">Acciones</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (misProyectos != null && !misProyectos.isEmpty()) {
                for (Proyectos p : misProyectos) {
                    LocalDate fechaFinal = ((Date)p.getFechaFinal()).toLocalDate();
                    long diasRestantes = ChronoUnit.DAYS.between(hoy, fechaFinal);

                    String color = "#22c55e"; // verde por defecto
                    String estado = "En curso";
                    String tooltip = "Proyecto dentro del plazo";

                    if (diasRestantes < 0) {
                        color = "#6b7280"; estado = "Vencido"; tooltip = "Proyecto superó la fecha límite";
                    } else if (diasRestantes <= 1) {
                        color = "#ef4444"; estado = "Por vencer"; tooltip = "Queda menos de 1 día";
                    } else if (diasRestantes <= 3) {
                        color = "#facc15"; estado = "Próximo a vencer"; tooltip = "Proyecto próximo a la fecha límite";
                    }

                    // Obtener datos desde los mapas
                    int totalTareas = totalTareasPorProyecto != null && totalTareasPorProyecto.get(p.getIdProyecto()) != null
                                      ? totalTareasPorProyecto.get(p.getIdProyecto()) : 0;
                    int completadas = tareasCompletadasPorProyecto != null && tareasCompletadasPorProyecto.get(p.getIdProyecto()) != null
                                      ? tareasCompletadasPorProyecto.get(p.getIdProyecto()) : 0;

                    int porcentajeAvance = totalTareas > 0 ? (completadas * 100) / totalTareas : 0;
                    String colorBarra = porcentajeAvance >= 71 ? "#22c55e" : (porcentajeAvance >= 31 ? "#facc15" : "#ef4444");
        %>
            <tr style="text-align:center; border-bottom:1px solid #e5e7eb;">
                <td title="<%= tooltip %>">
                    <span style="display:inline-block; width:12px; height:12px; border-radius:50%; background:<%= color %>;"></span>
                </td>
                <td><%= p.getIdProyecto() %></td>
                <td style="text-align:left; padding-left:8px;"><strong><%= p.getNombreProyecto() %></strong></td>
                <td style="text-align:left; padding-left:8px;"><%= p.getDescripcion() %></td>
                <td><%= p.getFechaInicio() %></td>
                <td><%= p.getFechaFinal() %></td>
                <td>
                    <div style="background:#e5e7eb; border-radius:8px; height:14px; width:100%; overflow:hidden;">
                        <div style="width:<%= porcentajeAvance %>%; height:100%; background:<%= colorBarra %>; transition: width 0.3s;"></div>
                    </div>
                    <span style="font-size:12px; color:#374151;"><%= porcentajeAvance %>%</span>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/ControladorTareas" method="get" style="display:inline;">
                        <input type="hidden" name="accion" value="listarTareasPorProyecto">
                        <input type="hidden" name="idProyecto" value="<%= p.getIdProyecto() %>">
                        <button type="submit" style="background:#2563eb; color:white; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; font-weight:500; transition: background 0.2s;">
                            <i class="fas fa-tasks" style="margin-right:4px;"></i> Ver tareas
                        </button>
                    </form>
                </td>
            </tr>
        <%  }
            } else { %>
            <tr>
                <td colspan="8" style="text-align:center; padding:16px; color:#6b7280;">No tienes proyectos asignados.</td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
