<%-- 
    Document   : listarEquipos
    Created on : 8 oct 2025, 9:31:27 a.m.
    Author     : Heriberto
--%>

<%@page import="java.util.List"%>
<%@page import="modelo.Equipo"%>
<%@page import="modelo.EquipoDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mis Equipos</title>
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

  </style>
</head>
<body>
    <header>
        <h2>Lista de Equipos Registrados</h2>
    </header>
    
    <div class="container">
        <table>
            <tr>
                <th>Id equipo</th>
                <th>Nombre del equipo</th>
                <th>Id del docente</th>
            </tr>
            <%
        EquipoDAO dao = new EquipoDAO();
        List<Equipo> lista = dao.listarEquipos();
        for (Equipo e : lista) {
    %>
    <tr>
        <td><%=e.getIdEquipo()%></td>
        <td><%=e.getNombreEquipo()%></td>
        <td><%=e.getIdDocente()%></td>
    </tr>
    <%
        }
    %>
        </table>
    </div>

    
</body>
</html>
