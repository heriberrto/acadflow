<%@ page import="java.util.List" %>
<%@ page import="modelo.Tarea" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
    int idUsuarioSesion = (int) session.getAttribute("id");
    int idProyecto = (int) request.getAttribute("idProyecto");
%>

<div style="font-family:'Inter',sans-serif;padding:20px;background:#f8fafc;min-height:100vh;">
    <h2 style="text-align:center;color:#1e40af;font-weight:600;margin-bottom:30px;">
        Tablero de Tareas
    </h2>

    <!-- Botón para crear tarea -->
    <div style="text-align:right;margin-bottom:20px;">
        <button onclick="document.getElementById('modalCrear').style.display='block'"
                style="background:#1e40af;color:white;border:none;padding:10px 18px;border-radius:6px;font-weight:500;cursor:pointer;">
            + Nueva tarea
        </button>
    </div>

    <div style="display:flex;justify-content:space-between;gap:20px;margin-top:20px;">

        <!-- ======== BACKLOG (sin asignar) ======== -->
        <div style="flex:1;background:#f3f4f6;border-radius:8px;padding:15px;box-shadow:0 2px 6px rgba(0,0,0,0.08);">
            <h3 style="color:#374151;text-align:center;font-weight:600;text-transform:uppercase;font-size:14px;letter-spacing:0.5px;">
                Backlog
            </h3>
            <hr style="border:none;border-top:1px solid #e5e7eb;margin:10px 0;">

            <% for (Tarea t : tareas) {
                if (t.getAsignadoA() == 0) { %>
                <div style="background:white;border-left:4px solid #9ca3af;border-radius:6px;padding:12px;margin:10px 0;box-shadow:0 1px 4px rgba(0,0,0,0.08);">
                    <h4 style="margin:0;font-size:15px;font-weight:600;color:#111827;"><%=t.getTitulo()%></h4>
                    <p style="margin:5px 0;font-size:14px;color:#4b5563;"><%=t.getDescripcion()%></p>
                    <p style="font-size:13px;color:#6b7280;">Responsable: <span style="font-style:italic;">Sin asignar</span></p>

                    <!-- Botón tomar tarea -->
                    <form method="post" action="ControladorTareas">
                        <input type="hidden" name="accion" value="asignarTarea">
                        <input type="hidden" name="idTarea" value="<%=t.getIdTarea()%>">
                        <input type="hidden" name="idProyecto" value="<%=idProyecto%>">
                        <button type="submit" style="background:#22c55e;color:white;border:none;padding:6px 12px;border-radius:4px;font-size:13px;cursor:pointer;">
                            Tomar tarea
                        </button>
                    </form>
                </div>
            <% } } %>
        </div>

        <!-- ======== RESTO DE ESTADOS ======== -->
        <% String[] estados = {"pendiente", "en progreso", "en revisión", "completada"}; %>
        <% String[] colores = {"#ef4444", "#3b82f6", "#facc15", "#22c55e"}; %>

        <% for (int i = 0; i < estados.length; i++) { %>
        <div style="flex:1;background:#f9fafb;border-radius:8px;padding:15px;box-shadow:0 2px 6px rgba(0,0,0,0.08);">
            <h3 style="color:<%=colores[i]%>;text-align:center;font-weight:600;text-transform:uppercase;font-size:14px;letter-spacing:0.5px;">
                <%= estados[i].replace("_"," ") %>
            </h3>
            <hr style="border:none;border-top:1px solid #e5e7eb;margin:10px 0;">

            <% for (Tarea t : tareas) {
                if (t.getAsignadoA() != 0 && t.getEstado().equals(estados[i])) { %>
                <div style="background:white;border-left:4px solid <%=colores[i]%>;border-radius:6px;padding:12px;margin:10px 0;box-shadow:0 1px 4px rgba(0,0,0,0.08);">
                    <h4 style="margin:0;font-size:15px;font-weight:600;color:#111827;"><%=t.getTitulo()%></h4>
                    <p style="margin:5px 0;font-size:14px;color:#4b5563;"><%=t.getDescripcion()%></p>
                    <p style="font-size:13px;color:#6b7280;">Responsable: <%=t.getNombreResponsable()%></p>

                    <% if (t.getAsignadoA() == idUsuarioSesion) { %>
                        <!-- Cambiar estado -->
                        <form action="ControladorTareas" method="post" style="margin-top:6px;">
                            <input type="hidden" name="accion" value="actualizarEstado">
                            <input type="hidden" name="idTarea" value="<%=t.getIdTarea()%>">
                            <input type="hidden" name="idProyecto" value="<%=idProyecto%>">
                            <select name="nuevoEstado" style="padding:6px 8px;border-radius:4px;border:1px solid #d1d5db;font-size:13px;">
                                <option value="pendiente" <%=t.getEstado().equals("pendiente")?"selected":""%>>Pendiente</option>
                                <option value="en progreso" <%=t.getEstado().equals("en progreso")?"selected":""%>>En progreso</option>
                                <option value="en revisión" <%=t.getEstado().equals("en revisión")?"selected":""%>>En revisión</option>
                                <option value="completada" <%=t.getEstado().equals("completada")?"selected":""%>>Completada</option>
                            </select>
                            <button type="submit" style="background:#1e40af;color:white;border:none;padding:5px 10px;border-radius:4px;margin-left:5px;font-size:13px;cursor:pointer;">
                                Guardar
                            </button>
                        </form>

                        <!-- Soltar tarea -->
                        <form method="post" action="ControladorTareas" style="margin-top:5px;">
                            <input type="hidden" name="accion" value="liberarTarea">
                            <input type="hidden" name="idTarea" value="<%=t.getIdTarea()%>">
                            <input type="hidden" name="idProyecto" value="<%=idProyecto%>">
                            <button type="submit" style="background:#dc2626;color:white;border:none;padding:5px 10px;border-radius:4px;font-size:13px;cursor:pointer;">
                                Soltar tarea
                            </button>
                        </form>
                    <% } %>
                </div>
            <% } } %>
        </div>
        <% } %>
    </div>
</div>

<!-- Modal Crear Tarea -->
<div id="modalCrear" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.4);z-index:100;">
    <div style="background:white;width:400px;margin:100px auto;padding:25px;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,0.15);">
        <h3 style="color:#1e40af;text-align:center;margin-bottom:15px;">Nueva Tarea</h3>
        <form method="post" action="ControladorTareas">
            <input type="hidden" name="accion" value="crearTarea">
            <input type="hidden" name="idProyecto" value="<%=idProyecto%>">

            <label style="font-size:14px;color:#374151;">Título</label>
            <input type="text" name="titulo" required style="width:100%;margin-bottom:10px;padding:8px;border:1px solid #d1d5db;border-radius:6px;">

            <label style="font-size:14px;color:#374151;">Descripción</label>
            <textarea name="descripcion" style="width:100%;margin-bottom:10px;padding:8px;border:1px solid #d1d5db;border-radius:6px;"></textarea>

            <label style="font-size:14px;color:#374151;">Prioridad</label>
            <select name="prioridad" style="width:100%;margin-bottom:15px;padding:8px;border:1px solid #d1d5db;border-radius:6px;">
                <option value="baja">Baja</option>
                <option value="media" selected>Media</option>
                <option value="alta">Alta</option>
            </select>

            <div style="text-align:center;">
                <button type="submit" style="background:#1e40af;color:white;padding:8px 15px;border:none;border-radius:6px;margin-right:5px;cursor:pointer;">
                    Crear
                </button>
                <button type="button" onclick="document.getElementById('modalCrear').style.display='none'"
                        style="background:#6b7280;color:white;padding:8px 15px;border:none;border-radius:6px;cursor:pointer;">
                    Cancelar
                </button>
            </div>
        </form>
    </div>
</div>
