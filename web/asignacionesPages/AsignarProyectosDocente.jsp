<%-- 
    Document   : AsignarProyectosDocente
    Created on : 7 oct 2025, 7:10:21 p.m.
    Author     : Heriberto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asignar Proyectos</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        

  <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --success: #10b981;
            --error: #ef4444;
            --glass-bg: rgba(255, 255, 255, 0.3);
            --glass-border: rgba(255, 255, 255, 0.25);
        }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #dbeafe, #f0fdf4);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #111827;
        }

        .container {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border-radius: 20px;
            padding: 2.5rem;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 1.5rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        input {
            padding: 0.9rem;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            background: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            outline: none;
            transition: all 0.3s ease;
        }

        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }

        .btn {
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 0.9rem;
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

        .message {
            margin-top: 1rem;
            padding: 0.8rem 1rem;
            border-radius: 10px;
            font-weight: 600;
        }

        .message.success {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid var(--success);
            color: var(--success);
        }

        .message.error {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid var(--error);
            color: var(--error);
        }

        .back-btn {
            margin-top: 1.2rem;
            background: transparent;
            border: none;
            color: var(--primary-dark);
            font-weight: 600;
            cursor: pointer;
            text-decoration: underline;
            font-size: 0.95rem;
        }

        .back-btn:hover {
            color: var(--primary);
        }
    </style>
    </head>
    <body>
        <form action="${pageContext.request.contextPath}/ControladorProyectos" method="post">
            <input type="hidden" name="accion" value="crearProyecto">
            <input type="text" name="nombreProyecto" placeholder="Titulo del proyecto" required>
            <input type="text" name="descripcion" placeholder="Descripcion" required>
            <input type="date" name="fechaInicio" value="2025-10-7" placeholder="fecha de asignacion" required>
            <input type="date" name="fechaLimite" value="2025-10-7" placeholder="fecha limite" required>
            <input type="number" name="creadoPor" placeholder="creadoPor" required>
            <button type="submit" class="btn">Asignar</button>
        </form>
            
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="message success">
                    <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="message error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <button class="btn btn-back" onclick="window.location.href='http://localhost:8081/Proyecto_AcadFlow/dashboard.jsp?page=proyectodocente'">
                ⬅ Volver atrás
            </button>
    </body>
</html>
