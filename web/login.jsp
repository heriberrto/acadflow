<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Iniciar Sesión - AcadFlow</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    /* ====== ESTILOS (igual que los que ya tienes) ====== */
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
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    header {
      display: flex;
      align-items: center;
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
      color: var(--primary);
      cursor: pointer;
      font-weight: 700;
      transition: all 0.3s ease;
    }
    header h1:hover {
      color: var(--primary-dark);
      transform: scale(1.05);
    }
    .login-container {
      flex: 1;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 2rem;
      margin-top: 80px;
    }
    .login-box {
      background: var(--glass-bg);
      border: 1px solid var(--glass-border);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      padding: 2.5rem;
      border-radius: 20px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
      text-align: center;
      color: #111827;
    }
    .login-box h2 {
      margin-bottom: 1.5rem;
      font-size: 1.8rem;
      font-weight: 700;
      color: var(--primary-dark);
    }
    .login-box input {
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
    .login-box input:focus {
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
    .signup-text {
      margin-top: 1rem;
      font-size: 0.9rem;
      color: #374151;
    }
    .signup-text a {
      color: var(--primary);
      text-decoration: none;
      font-weight: 600;
    }
    .signup-text a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
    
   <%
    String msg = request.getParameter("msg");
    if ("logout".equals(msg)) {
%>
    <script>alert("Sesión cerrada correctamente.");</script>
<%
    }
%>

  <header>
    <h1 onclick="window.location.href='index.jsp'">AcadFlow</h1>
  </header>

  <div class="login-container">
    <div class="login-box">
      <h2>Iniciar Sesión</h2>
      <% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
  <div style="color: red; font-weight: bold; margin-bottom: 1rem;">
    <%= error %>
  </div>
<% } %>

     <form action="ctrolValidar" method="post">
  <input type="hidden" name="accion" value="Ingresar">
  
  <input type="email" name="cusuario" placeholder="Correo electrónico" required>
  <input type="password" name="cclave" placeholder="Contraseña" required>
  <button type="submit" class="btn">Ingresar</button>
</form>

      <p class="signup-text">¿No tienes cuenta? <a href="registro.jsp">Crea una aquí</a></p>
    </div>
  </div>
</body>
</html>
