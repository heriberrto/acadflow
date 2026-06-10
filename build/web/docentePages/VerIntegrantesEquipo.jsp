<%@ page import="java.util.List" %>
<%@ page import="modelo.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Usuario> integrantes = (List<Usuario>) request.getAttribute("integrantes");
    int idEquipo = (int) request.getAttribute("idEquipo");
%>

<!-- ==== ESTILOS BASE ==== -->
<style>
    body {
        font-family: 'Inter', sans-serif;
        background-color: #f9fafb;
        margin: 0;
        padding: 0;
    }
    .container {
        padding: 30px;
        max-width: 900px;
        margin: 0 auto;
    }
    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 25px;
    }
    h2 {
        color: #1e40af;
        font-weight: 600;
    }
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 14px;
        border-radius: 6px;
        font-size: 14px;
        text-decoration: none;
        cursor: pointer;
        border: none;
    }
    .btn-primary {
        background-color: #1e40af;
        color: white;
    }
    .btn-danger {
        background-color: #dc2626;
        color: white;
    }
    .btn-secondary {
        background-color: #e5e7eb;
        color: #1f2937;
    }
    .btn:hover {
        opacity: 0.9;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }
    th, td {
        padding: 12px;
        text-align: left;
    }
    thead {
        background: #e5e7eb;
        color: #374151;
        font-weight: 600;
    }
    tr:nth-child(even) {
        background-color: #f9fafb;
    }
    tr:hover {
        background-color: #eef2ff;
    }
    .actions {
        display: flex;
        gap: 8px;
    }
    .no-data {
        text-align: center;
        color: #6b7280;
        padding: 20px;
    }
    /* ==== MODAL ==== */
    .modal {
        display: none;
        position: fixed;
        z-index: 50;
        left: 0; top: 0;
        width: 100%; height: 100%;
        background: rgba(0,0,0,0.4);
        align-items: center;
        justify-content: center;
    }
    .modal-content {
        background: white;
        border-radius: 8px;
        padding: 25px;
        width: 400px;
        box-shadow: 0 2px 20px rgba(0,0,0,0.3);
    }
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
    }
    .modal-header h3 {
        color: #1e40af;
        margin: 0;
    }
    .close {
        cursor: pointer;
        font-size: 18px;
        font-weight: bold;
        color: #6b7280;
    }
    .search-input {
        width: 100%;
        padding: 8px;
        border-radius: 6px;
        border: 1px solid #d1d5db;
        margin-bottom: 10px;
    }
    .student-list {
        max-height: 250px;
        overflow-y: auto;
        border: 1px solid #e5e7eb;
        border-radius: 6px;
    }
    .student-item {
        padding: 8px 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #f3f4f6;
    }
    .student-item:hover {
        background-color: #eef2ff;
    }
</style>

<div class="container">
    <div class="header">
        <h2><i class="fas fa-users"></i> Integrantes del Equipo #<%= idEquipo %></h2>
        <div>
            <button class="btn btn-primary" id="btnOpenModal">
                <i class="fas fa-user-plus"></i> Agregar integrante
            </button>
            <a href="ControladorEquipo?accion=listarEquipos" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Volver
            </a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre completo</th>
                <th>Correo</th>
                <th style="width:120px;">Acciones</th>
            </tr>
        </thead>
        <tbody>
            <% if (integrantes != null && !integrantes.isEmpty()) {
                for (Usuario u : integrantes) { %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getNombres() %> <%= u.getApellidos() %></td>
                    <td><%= u.getCorreo() %></td>
                    <td class="actions">
                        <form action="ControladorEquipo" method="post" style="margin:0;">
                            <input type="hidden" name="accion" value="eliminarIntegrante">
                            <input type="hidden" name="idUsuario" value="<%= u.getId() %>">
                            <input type="hidden" name="idEquipo" value="<%= idEquipo %>">
                            <button class="btn btn-danger" type="submit" title="Eliminar integrante">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            <% } } else { %>
                <tr><td colspan="4" class="no-data">No hay integrantes registrados en este equipo.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- ==== MODAL AGREGAR ==== -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-plus"></i> Agregar estudiante</h3>
            <span class="close" id="btnCloseModal">&times;</span>
        </div>

        <form action="ControladorEquipo" method="post">
            <input type="hidden" name="accion" value="agregarIntegrante">
            <input type="hidden" name="idEquipo" value="<%= idEquipo %>">

            <label style="font-size:14px;color:#374151;">Seleccione un estudiante</label>
            <select name="idUsuario" required
                    style="width:100%;margin-bottom:15px;padding:8px;border:1px solid #d1d5db;border-radius:6px;">
                <option value="">Seleccione...</option>
                <%
                    List<Usuario> estudiantes = (List<Usuario>) request.getAttribute("estudiantes");
                    if (estudiantes != null) {
                        for (Usuario e : estudiantes) {
                %>
                <option value="<%= e.getId() %>"><%= e.getNombres() %> <%= e.getApellidos() %></option>
                <%
                        }
                    }
                %>
            </select>

            <div style="text-align:center;">
                <button type="submit" class="btn btn-primary">Agregar</button>
                <button type="button" id="btnCloseModal2" class="btn btn-secondary">Cancelar</button>
            </div>
        </form>
    </div>
</div>

<script>
    const modal = document.getElementById('addModal');
    const btnOpen = document.getElementById('btnOpenModal');
    const btnClose = document.getElementById('btnCloseModal');
    const btnClose2 = document.getElementById('btnCloseModal2');

    btnOpen.onclick = () => modal.style.display = 'flex';
    btnClose.onclick = () => modal.style.display = 'none';
    btnClose2.onclick = () => modal.style.display = 'none';
    window.onclick = (e) => { if (e.target === modal) modal.style.display = 'none'; };
</script>

