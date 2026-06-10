<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Proyectos"%>
<%@page import="modelo.ProyectosDAO"%>
<%@page import="modelo.EquipoDAO"%>
<%@page import="modelo.Equipo"%>

<style>
    :root {
        --primary: #2563eb;
        --primary-dark: #1e40af;
        --success: #10b981;
        --error: #ef4444;
    }

    h1 {
        color: var(--primary-dark);
        margin-bottom: 1.5rem;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    th, td {
        padding: 1rem;
        text-align: left;
    }

    th {
        background: rgba(37,99,235,0.2);
        color: var(--primary-dark);
        text-transform: uppercase;
        font-size: 0.9rem;
    }

    tr:nth-child(even) { background: #f9fafb; }

    tr:hover {
        background: rgba(37,99,235,0.1);
        cursor: pointer;
    }

    .btn {
        background: var(--primary);
        color: #fff;
        padding: 0.9rem 1.5rem;
        border: none;
        border-radius: 10px;
        font-size: 1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
    }

    .btn:hover {
        background: var(--primary-dark);
        transform: translateY(-2px);
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 20;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.4);
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background: #fff;
        padding: 2rem;
        border-radius: 16px;
        width: 400px;
        box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        position: relative;
    }

    .modal-content h2 {
        margin-top: 0;
        text-align: center;
        color: var(--primary-dark);
    }

    .close {
        position: absolute;
        right: 15px;
        top: 10px;
        font-size: 1.5rem;
        cursor: pointer;
        color: #555;
    }

    .close:hover {
        color: var(--error);
    }

    input, select {
        width: 100%;
        padding: 0.8rem;
        margin-top: 0.8rem;
        border-radius: 10px;
        border: 1px solid #d1d5db;
        font-size: 1rem;
    }

    input:focus {
        border-color: var(--primary);
        outline: none;
    }

    .message {
        margin-top: 1rem;
        padding: 0.8rem;
        text-align: center;
        border-radius: 10px;
    }

    .message.success {
        background: rgba(16,185,129,0.1);
        color: var(--success);
    }

    .message.error {
        background: rgba(239,68,68,0.1);
        color: var(--error);
    }
</style>

<h1>Gestión de Proyectos</h1>

<%
    ProyectosDAO pdao = new ProyectosDAO();
    List<Proyectos> lista = pdao.ListarProyectos();

    EquipoDAO edao = new EquipoDAO();
    List<Equipo> equipos = edao.listarEquipos();
%>

<table>
    <tr>
        <th>ID</th>
        <th>Nombre del proyecto</th>
        <th>Descripción</th>
        <th>Fecha de inicio</th>
        <th>Fecha final</th>
        <th>ID de creador</th>
    </tr>

    <% for (Proyectos p : lista) { %>
        <tr onclick="abrirModalAsignar(<%=p.getIdProyecto()%>, '<%=p.getNombreProyecto()%>')">
            <td><%=p.getIdProyecto()%></td>
            <td><%=p.getNombreProyecto()%></td>
            <td><%=p.getDescripcion()%></td>
            <td><%=p.getFechaInicio()%></td>
            <td><%=p.getFechaFinal()%></td>
            <td><%=p.getCreadoPor()%></td>
        </tr>
    <% } %>
</table>

<div style="margin-top: 2rem; text-align:center;">
    <button class="btn" onclick="abrirModalCrear()">+ Crear Proyecto</button>
</div>

<% if (request.getAttribute("mensaje") != null) { %>
    <div class="message success"><%= request.getAttribute("mensaje") %></div>
<% } %>
<% if (request.getAttribute("error") != null) { %>
    <div class="message error"><%= request.getAttribute("error") %></div>
<% } %>

<!-- ==== MODAL CREAR PROYECTO ==== -->
<div id="modalCrear" class="modal">
    <div class="modal-content">
        <span class="close" onclick="cerrarModalCrear()">&times;</span>
        <h2>Crear Proyecto</h2>
        <form action="${pageContext.request.contextPath}/ControladorProyectos" method="post">
            <input type="hidden" name="accion" value="crearProyecto">
            <input type="text" name="nombreProyecto" placeholder="Título del proyecto" required>
            <input type="text" name="descripcion" placeholder="Descripción" required>
            <label>Fecha de inicio:</label>
            <input type="date" name="fechaInicio" required>
            <label>Fecha final:</label>
            <input type="date" name="fechaLimite" required>
            <button type="submit" class="btn" style="width:100%; margin-top:1rem;">Crear</button>
        </form>
    </div>
</div>

<!-- ==== MODAL ASIGNAR EQUIPO ==== -->
<div id="modalAsignar" class="modal">
    <div class="modal-content">
        <span class="close" onclick="cerrarModalAsignar()">&times;</span>
        <h2>Asignar Equipo</h2>

        <form action="${pageContext.request.contextPath}/ControladorProyectos" method="post">
            <input type="hidden" name="accion" value="agregarEquipo">
            <input type="hidden" id="idProyectoModal" name="idProyecto">

            <label>Proyecto seleccionado:</label>
            <input type="text" id="nombreProyectoModal" readonly>

            <label>Selecciona un equipo:</label>
            <select name="idEquipo" required>
                <option value="">-- Selecciona un equipo --</option>
                <% for (Equipo e : equipos) { %>
                    <option value="<%=e.getIdEquipo()%>"><%=e.getNombreEquipo()%></option>
                <% } %>
            </select>

            <button type="submit" class="btn" style="width:100%; margin-top:1rem;">Asignar</button>
        </form>
    </div>
</div>

<script>
    function abrirModalCrear() {
        document.getElementById("modalCrear").style.display = "flex";
    }
    function cerrarModalCrear() {
        document.getElementById("modalCrear").style.display = "none";
    }

    function abrirModalAsignar(id, nombre) {
        document.getElementById("modalAsignar").style.display = "flex";
        document.getElementById("idProyectoModal").value = id;
        document.getElementById("nombreProyectoModal").value = nombre;
    }
    function cerrarModalAsignar() {
        document.getElementById("modalAsignar").style.display = "none";
    }

    window.onclick = function(event) {
        const modalCrear = document.getElementById("modalCrear");
        const modalAsignar = document.getElementById("modalAsignar");
        if (event.target === modalCrear) modalCrear.style.display = "none";
        if (event.target === modalAsignar) modalAsignar.style.display = "none";
    };
</script>
