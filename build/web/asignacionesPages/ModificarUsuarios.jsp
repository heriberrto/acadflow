<%-- 
    Document   : ModificarUsuarios
    Created on : 8 oct 2025, 5:49:03 p.m.
    Author     : Heriberto
--%>

<%@page import="modelo.Usuario"%>
<%@page import="modelo.UsuarioDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar Usuario</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --glass-bg: rgba(255, 255, 255, 0.15);
            --glass-border: rgba(255, 255, 255, 0.25);
        }
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
            color: #111827;
            min-height: 100vh;
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
        .back-btn {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            color: var(--primary-dark);
            transform: translateX(-4px);
        }
        .back-btn svg {
            width: 18px;
            height: 18px;
            margin-right: 6px;
        }

        /* ===== FORMULARIO ===== */
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            margin-top: 80px;
        }
        .form-box {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
        }
        .form-box h2 {
            margin-bottom: 1.5rem;
            text-align: center;
            color: var(--primary-dark);
            font-size: 1.8rem;
            font-weight: 700;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #374151;
            text-align: left;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.9rem;
            margin-bottom: 1rem;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            outline: none;
            background: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            transition: border 0.3s ease, box-shadow 0.3s ease;
        }
        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
        }
        .btn {
            width: 100%;
            padding: 0.9rem;
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
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.5);
        }
    </style>
</head>
<body>
    <header>
        <button class="back-btn" onclick="window.location.href='http://localhost:8081/Proyecto_AcadFlow/dashboard.jsp?page=GestionEstudiantes'">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Volver atrás
        </button>
    </header>

    <%
        UsuarioDAO udao = new UsuarioDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        Usuario a = udao.buscarUsuarioPorId(id);
    %>

    <div class="container">
        <form class="form-box" method="post" action="${pageContext.request.contextPath}/EditarUsuario">
            <h2>Modificar Usuario</h2>
            <input type="hidden" name="id" value="<%=a.getId()%>"/>

            <label>Correo:</label>
            <input type="text" name="cmail" value="<%=a.getCorreo()%>" required>

            <label>Nombres:</label>
            <input type="text" name="cnombre" value="<%=a.getNombres()%>" required>

            <label>Apellidos:</label>
            <input type="text" name="capellido" value="<%=a.getApellidos()%>" required>

            <label>Clave:</label>
            <input type="password" name="cclave" value="<%=a.getClave()%>" required>

            <button type="submit" class="btn">Actualizar</button>
        </form>
    </div>
</body>
</html>
