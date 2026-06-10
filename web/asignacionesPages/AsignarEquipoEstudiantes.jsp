<%-- 
    Document   : AsignarTareaDocente
    Created on : 7 oct 2025, 6:55:46 p.m.
    Author     : Heriberto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asignar Tarea - AcadFlow</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #2563eb;
                --primary-dark: #1e40af;
                --glass-bg: rgba(255, 255, 255, 0.25);
                --glass-border: rgba(255, 255, 255, 0.4);
                --gray-light: #f1f5f9;
            }

            body {
                margin: 0;
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
                color: #111827;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 1rem;
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
                text-align: center;
                color: #111827;
            }

            h2 {
                margin-bottom: 1.5rem;
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary-dark);
            }

            form {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            input {
                width: 100%;
                padding: 0.9rem;
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

            .btn-back {
                margin-top: 1.5rem;
                background: #64748b;
                box-shadow: 0 4px 14px rgba(100, 116, 139, 0.3);
            }

            .btn-back:hover {
                background: #475569;
                box-shadow: 0 6px 18px rgba(100, 116, 139, 0.4);
            }

            .message {
                margin-top: 1rem;
                font-weight: 600;
                padding: 0.8rem;
                border-radius: 10px;
                text-align: center;
            }

            .success {
                color: #065f46;
                background: #d1fae5;
                border: 1px solid #10b981;
            }

            .error {
                color: #991b1b;
                background: #fee2e2;
                border: 1px solid #f87171;
            }
        </style>
    </head>
    <body>
        <div class="form-box">
            <h2>Asignar Tarea a Docente</h2>

            <form action="${pageContext.request.contextPath}/ControladorEquipo" method="post">
                <input type="hidden" name="accion" value="agregarEstudiante">
                <input type="number" name="idUsuario" placeholder="Identificador del estudiante" required>
                <input type="number" name="idEquipo" placeholder="Identificador del equipo" required>
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

            <button class="btn btn-back" onclick="window.location.href='http://localhost:8081/Proyecto_AcadFlow/dashboard.jsp?page=AsignacionDeEquipos'">
                ⬅ Volver atrás
            </button>
        </div>
    </body>
</html>
