<%-- 
    Document   : registro
    Created on : 28/08/2025, 9:45:19 a. m.
    Author     : Mr_Fagua
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registro - AcadFlow</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #2563eb;
                --primary-dark: #1e40af;
                --bg-light: #f0f4ff;
                --glass-bg: rgba(255, 255, 255, 0.25);
                --glass-border: rgba(255, 255, 255, 0.18);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
                color: #111827;
                line-height: 1.6;
            }

            /* Header */
            header {
                display: flex;
                align-items: center;
                padding: 18px 50px;
                background: var(--glass-bg);
                border-bottom: 1px solid var(--glass-border);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                position: fixed;
                top: 0;
                width: 100%;
                z-index: 1000;
                height: 75px;
            }

            header h1 {
                margin: 0;
                font-size: 1.6rem;
                color: var(--primary);
                cursor: pointer;
                font-weight: 700;
                transition: all 0.3s ease;
            }
            header h1:hover {
                color: var(--primary-dark);
                transform: scale(1.05);
            }

            /* Registro */
            .hero {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 160px 20px 100px;
            }

            .hero-content {
                width: 100%;
                max-width: 420px;
                background: var(--glass-bg);
                border: 1px solid var(--glass-border);
                border-radius: 20px;
                padding: 40px;
                backdrop-filter: blur(14px);
                -webkit-backdrop-filter: blur(14px);
                box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                text-align: center;
            }

            .hero-content h1 {
                font-size: 30px;
                font-weight: 700;
                margin-bottom: 20px;
                color: #111827;
            }

            form {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            input, select {
                width: 100%;
                padding: 14px 16px;
                font-size: 16px;
                border-radius: 10px;
                border: 1px solid #bbb;
                outline: none;
                transition: all 0.3s ease;
                background: rgba(255,255,255,0.6);
            }

            input:focus, select:focus {
                border: 1px solid var(--primary);
                box-shadow: 0 0 8px rgba(37,99,235,0.3);
            }

            .btn {
                background: var(--primary);
                color: #fff;
                padding: 14px;
                font-size: 17px;
                border: none;
                border-radius: 12px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 6px 18px rgba(37, 99, 235, 0.4);
            }

            .btn:hover {
                background-color: var(--primary-dark);
                transform: scale(1.05);
            }

            .extra-links {
                margin-top: 15px;
                font-size: 14px;
            }

            .extra-links a {
                color: var(--primary);
                text-decoration: none;
                font-weight: 600;
            }

            .extra-links a:hover {
                text-decoration: underline;
            }

            /* Footer */
            footer {
                background: var(--glass-bg);
                border-top: 1px solid var(--glass-border);
                text-align: center;
                padding: 20px;
                color: #374151;
                font-size: 13px;
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <header>
            <h1 onclick="window.location.href = 'index.jsp'">AcadFlow</h1>
        </header>

        <!-- Registro -->
        <section class="hero">
            <div class="hero-content">
                <h1>Crear cuenta</h1>
                <form id="form_registro" method="post" action="controladorUsuario">
                    <input type="text" name="nombre" placeholder="Nombres" required>
                    <input type="text" name="apellido" placeholder="Apellidos" required>
                    <input type="email" name="correo" placeholder="Correo institucional" required>
                    <select name="rol" required>
                        <option value="" disabled selected>Selecciona tu rol</option>
                        <option value="estudiante">Estudiante</option>
                        <option value="docente">Docente</option>
                    </select>
                    <input type="password" name="password" placeholder="Contraseña" required>
                    <input type="password" name="confirmar" placeholder="Confirmar contraseña" required>
                    <button type="submit" class="btn">Registrarse</button>
                    <% if (request.getAttribute("mensaje") != null) {%>
                    <p style="color:green;"><%= request.getAttribute("mensaje")%></p>
                    <% } %>
                    <% if (request.getAttribute("error") != null) {%>
                    <p style="color:red;"><%= request.getAttribute("error")%></p>
                    <% }%>

                </form>
                <div class="extra-links">
                    <p>¿Ya tienes una cuenta? <a href="login.jsp">Inicia sesión</a></p>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <p>© 2025 AcadFlow. Todos los derechos reservados.</p>
            <p>Contacto: soporte@acadflow.com</p>
        </footer>

    </body>
</html>
