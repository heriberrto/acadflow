<%-- 
    Document   : EliminarModificarEstudiantes
    Created on : 8 oct 2025, 4:42:43 p.m.
    Author     : Heriberto
--%>
<%@page import="java.util.List"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
      --primary: #2563eb;
      --primary-dark: #1e40af;
      --glass-bg: rgba(255, 255, 255, 0.15);
      --glass-border: rgba(255, 255, 255, 0.25);
      --text-color: #111827;
      --success: #10b981;
      --error: #ef4444;
    }

    body {
      margin: 0;
      font-family: 'Inter', sans-serif;
      background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
      color: var(--text-color);
      height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* ===== HEADER ===== */
    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1rem 2rem;
      background: var(--glass-bg);
      border-bottom: 1px solid var(--glass-border);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      z-index: 1000;
    }

    header h1 {
      margin: 0;
      font-size: 1.6rem;
      color: var(--primary-dark);
      font-weight: 700;
      letter-spacing: 0.5px;
    }

    .back-btn {
      padding: 0.6rem 1.2rem;
      border: none;
      border-radius: 12px;
      background: var(--primary);
      color: #fff;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
    }

    .back-btn:hover {
      background: var(--primary-dark);
      transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(37, 99, 235, 0.5);
    }

    /* ===== CONTENEDOR PRINCIPAL ===== */
    .container {
      flex: 1;
      margin-top: 100px;
      padding: 2rem;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    h2 {
      color: var(--primary-dark);
      font-size: 2rem;
      margin-bottom: 2rem;
      text-align: center;
      font-weight: 700;
      letter-spacing: 0.5px;
    }

    /* ===== TABLA ===== */
    table {
      width: 90%;
      max-width: 1000px;
      border-collapse: collapse;
      background: var(--glass-bg);
      backdrop-filter: blur(12px);
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    }

    th, td {
      padding: 1rem;
      text-align: left;
    }

    th {
      background: rgba(37, 99, 235, 0.2);
      color: var(--primary-dark);
      font-weight: 700;
      text-transform: uppercase;
      font-size: 0.9rem;
      letter-spacing: 0.5px;
    }

    tr:nth-child(even) {
      background: rgba(255, 255, 255, 0.1);
    }

    tr:hover {
      background: rgba(37, 99, 235, 0.1);
      transform: scale(1.01);
      transition: all 0.2s ease;
    }

    td {
      font-size: 1rem;
      color: #1f2937;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }

    /* ===== BOTONES ===== */
    .action-btn {
      text-decoration: none;
      padding: 0.5rem 1rem;
      border-radius: 10px;
      font-weight: 600;
      transition: all 0.3s ease;
      font-size: 0.9rem;
      margin-right: 0.4rem;
      color: white;
    }

    .edit {
      background: var(--success);
      box-shadow: 0 4px 10px rgba(16, 185, 129, 0.4);
    }

    .edit:hover {
      background: #059669;
      transform: translateY(-2px);
    }

    .delete {
      background: var(--error);
      box-shadow: 0 4px 10px rgba(239, 68, 68, 0.4);
    }

    .delete:hover {
      background: #dc2626;
      transform: translateY(-2px);
    }

    /* ===== SCROLL ===== */
    ::-webkit-scrollbar {
      width: 10px;
    }

    ::-webkit-scrollbar-thumb {
      background: var(--primary);
      border-radius: 10px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: var(--primary-dark);
    }
    /* ===== MODAL ===== */
    .modal {
      display: none;
      position: fixed;
      z-index: 2000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background: white;
      padding: 2rem;
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.2);
      width: 90%;
      max-width: 400px;
      position: relative;
      animation: fadeIn 0.3s ease;
    }

    .cerrar {
      position: absolute;
      top: 12px;
      right: 16px;
      font-size: 1.5rem;
      color: #555;
      cursor: pointer;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: scale(0.9); }
      to { opacity: 1; transform: scale(1); }
    }

    label {
      display: block;
      font-weight: 600;
      margin-top: 1rem;
      margin-bottom: 0.5rem;
    }

    input[type="text"], input[type="password"] {
      width: 100%;
      padding: 0.8rem;
      border-radius: 10px;
      border: 1px solid #d1d5db;
      font-size: 1rem;
    }

    .btn {
      width: 100%;
      padding: 0.9rem;
      margin-top: 1.5rem;
      border: none;
      border-radius: 12px;
      background: var(--primary);
      color: #fff;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
    }

    .btn:hover {
      background: var(--primary-dark);
      transform: translateY(-2px);
    }
        </style>
        <title>Gestion de usuarios</title>
    </head>
    <body>
        <%--
        <button class="btn" onclick="window.location.href='asignacionesPages/ListaUsuarios.jsp'">Editar Estudiantes</button>
        --%>
        <div class="container">
    <h2>Listado de Usuarios Registrados</h2>

    <table>
      <tr>
        <th>Identificación</th>
        <th>Nombres</th>
        <th>Apellidos</th>
        <th>Correo</th>
        <th>Acciones</th>
      </tr>

      <%
        UsuarioDAO udao = new UsuarioDAO();
        List<Usuario> lista = udao.listarEstudiantes();
        for(Usuario a : lista){
      %>
      <tr>
        <td><%=a.getId()%></td>
        <td><%=a.getNombres()%></td>
        <td><%=a.getApellidos()%></td>
        <td><%=a.getCorreo()%></td>
        <td>
          <a href="#"
             class="action-btn edit"
             data-id="<%=a.getId()%>"
             data-nombre="<%=a.getNombres()%>"
             data-apellido="<%=a.getApellidos()%>"
             data-correo="<%=a.getCorreo()%>"
             data-clave="<%=a.getClave()%>"
             onclick="abrirModal(this)">
             Editar
          </a>
          <a class="action-btn delete" href="${pageContext.request.contextPath}/EliminarUsuario?id=<%=a.getId()%>">Eliminar</a>
        </td>
      </tr>
      <%
        }
      %>
    </table>
  </div>
    <!-- ===== MODAL EDITAR ===== -->
  <div id="modalEditar" class="modal">
    <div class="modal-content">
      <span class="cerrar" onclick="cerrarModal()">&times;</span>
      <h2>Editar Usuario</h2>
      <form id="formEditar" method="post" action="${pageContext.request.contextPath}/EditarUsuario">
        <input type="hidden" name="id" id="modal-id">

        <label>Correo:</label>
        <input type="text" name="cmail" id="modal-correo" required>

        <label>Nombres:</label>
        <input type="text" name="cnombre" id="modal-nombre" required>

        <label>Apellidos:</label>
        <input type="text" name="capellido" id="modal-apellido" required>

        <label>Clave:</label>
        <input type="password" name="cclave" id="modal-clave">

        <button type="submit" class="btn">Actualizar</button>
      </form>
    </div>
  </div>

  <script>
  function abrirModal(boton) {
    // Cargar datos en el formulario
    document.getElementById('modal-id').value = boton.getAttribute('data-id');
    document.getElementById('modal-correo').value = boton.getAttribute('data-correo');
    document.getElementById('modal-nombre').value = boton.getAttribute('data-nombre');
    document.getElementById('modal-apellido').value = boton.getAttribute('data-apellido');
    //document.getElementById('modal-clave').value = boton.getAttribute('data-clave');

    // Mostrar modal
    document.getElementById('modalEditar').style.display = 'flex';
  }

  function cerrarModal() {
    document.getElementById('modalEditar').style.display = 'none';
  }

  // Cerrar si se hace clic fuera del contenido
  window.onclick = function(event) {
    const modal = document.getElementById('modalEditar');
    if (event.target === modal) {
      modal.style.display = 'none';
    }
  };
  </script>
    </body>
</html>
