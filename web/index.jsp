<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AcadFlow - Landing</title>
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
      justify-content: space-between;
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
      color: var(--primary);
      font-size: 26px;
      font-weight: 700;
    }

    header a {
      background: var(--primary);
      color: #fff;
      padding: 10px 18px;
      text-decoration: none;
      border-radius: 10px;
      font-weight: 600;
      transition: all 0.3s ease;
      font-size: 15px;
      box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }

    header a:hover {
      background-color: var(--primary-dark);
      transform: scale(1.05);
    }

    /* Hero Section */
    .hero {
      display: flex;
      flex-direction: column-reverse;
      align-items: center;
      justify-content: center;
      gap: 40px;
      padding: 160px 20px 100px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }

    /* fondo brillante */
    .hero::before {
      content: "";
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle at center, rgba(37,99,235,0.1) 0%, transparent 70%);
      animation: pulse 6s infinite alternate;
      z-index: 0;
    }

    @keyframes pulse {
      from { transform: scale(1); opacity: 0.6; }
      to { transform: scale(1.2); opacity: 1; }
    }

    .hero-content {
      position: relative;
      z-index: 1;
      max-width: 600px;
      background: var(--glass-bg);
      border: 1px solid var(--glass-border);
      border-radius: 20px;
      padding: 40px;
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      box-shadow: 0 8px 32px rgba(0,0,0,0.1);
      animation: fadeInUp 1s ease forwards;
      opacity: 0;
    }

    @keyframes fadeInUp {
      from { transform: translateY(30px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    .hero h2 {
      font-size: 40px;
      font-weight: 700;
      margin-bottom: 20px;
      color: #111827;
    }

    .hero p {
      font-size: 18px;
      margin-bottom: 20px;
      color: #374151;
    }

    /* Botón con gradiente y glow */
    .hero .btn {
      background: linear-gradient(135deg, #2563eb, #1e40af);
      color: #fff;
      padding: 14px 36px;
      font-size: 18px;
      border: none;
      border-radius: 14px;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 6px 18px rgba(37, 99, 235, 0.5);
    }

    .hero .btn:hover {
      transform: translateY(-3px) scale(1.05);
      box-shadow: 0 8px 24px rgba(37, 99, 235, 0.7);
      background: linear-gradient(135deg, #1e40af, #2563eb);
    }

    .hero-image {
      max-width: 420px;
      position: relative;
      z-index: 1;
      animation: fadeInUp 1.2s ease forwards;
    }

    .hero-image img {
      width: 100%;
      height: auto;
      border-radius: 20px;
      box-shadow: 0 6px 24px rgba(0,0,0,0.15);
    }

    /* RESPONSIVO */
    @media (max-width: 768px) {
      .hero {
        flex-direction: column-reverse;
        text-align: center;
        padding: 2rem 1rem;
      }

      .hero-content h2 {
        font-size: 2rem;
      }

      .hero-content p {
        font-size: 1rem;
      }

      .hero-image img {
        max-width: 250px;
        margin-top: 1.5rem;
      }
    }
    
    
/* About Section */
.about {
  padding: 80px 20px;
  background: var(--bg-light);
  display: flex;
  justify-content: center;
}

.about-container {
  max-width: 900px;
  background: var(--glass-bg);
  border: 1px solid var(--glass-border);
  border-radius: 20px;
  padding: 50px;
  text-align: center;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  box-shadow: 0 8px 30px rgba(0,0,0,0.1);
}

.about-container h2 {
  font-size: 32px;
  color: var(--primary-dark);
  margin-bottom: 20px;
  font-weight: 700;
}

.about-container p {
  font-size: 17px;
  color: #374151;
  margin-bottom: 15px;
  line-height: 1.7;
}


    /* Features */
    .features {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 30px;
      padding: 80px 40px;
    }

    .feature {
      background: var(--glass-bg);
      border: 1px solid var(--glass-border);
      border-radius: 20px;
      padding: 30px;
      text-align: center;
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      transition: all 0.3s ease;
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    }

    .feature:hover {
      transform: translateY(-6px) scale(1.02);
      box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    }

    .feature img {
      width: 80px;
      height: 80px;
      margin-bottom: 15px;
    }

    .feature h3 {
      font-size: 19px;
      margin-bottom: 10px;
      color: #111827;
    }

    .feature p {
      font-size: 15px;
      color: #4b5563;
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

    /* Responsividad */
    @media (min-width: 768px) {
      .hero {
        flex-direction: row;
        text-align: left;
        padding: 180px 80px 120px;
      }
      .hero-content {
        flex: 1;
      }
      .hero-image {
        flex: 1;
      }
      .hero h2 {
        font-size: 48px;
      }
    }
  </style>
</head>
<body>

 <!-- Header --> 
 <header> 
     <h1>AcadFlow</h1> 
     <a href="login.jsp">Iniciar Sesión</a> 
 </header>

  <!-- Hero Section -->
  <section class="hero">
    <div class="hero-content">
      <h2>Organiza y Potencia tus Proyectos Académicos</h2>
      <p>Una plataforma pensada para estudiantes y docentes que mejora la organización, colaboración y evaluación de proyectos.</p>
      <button class="btn" onclick="window.location.href='registro.jsp'">✨ Regístrate Gratis</button>
    </div>
    <div class="hero-image">
      <img src="https://img.icons8.com/clouds/500/student-male.png" alt="Imagen AcadFlow">
    </div>
  </section>
  
    <!-- Sección de Explicación -->
  <section class="about">
    <div class="about-container">
      <h2>¿Qué es AcadFlow?</h2>
      <p>
        AcadFlow es una plataforma diseñada para optimizar la gestión de proyectos académicos. 
        Nuestro objetivo es ofrecer a estudiantes y docentes un espacio donde puedan <strong>organizar sus tareas</strong>, 
        <strong>colaborar en equipo</strong>, y <strong>realizar un seguimiento claro del progreso</strong> de cada proyecto.
      </p>
      <p>
        Con AcadFlow, la comunicación y la productividad académica se simplifican, permitiendo que los usuarios se enfoquen en 
        lo más importante: <em>aprender y alcanzar sus objetivos</em>.
      </p>
    </div>
  </section>


  <!-- Features -->
  <section class="features">
    <div class="feature">
      <img src="https://img.icons8.com/color/96/security-checked.png" alt="Roles">
      <h3>Autenticación y Roles</h3>
      <p>Acceso seguro para estudiantes, docentes y administradores.</p>
    </div>
    <div class="feature">
      <img src="https://img.icons8.com/color/96/task.png" alt="Proyectos">
      <h3>Gestión de Proyectos</h3>
      <p>Crea, asigna y organiza tareas con fechas límite fácilmente.</p>
    </div>
    <div class="feature">
      <img src="https://img.icons8.com/color/96/appointment-reminders.png" alt="Notificaciones">
      <h3>Notificaciones Automáticas</h3>
      <p>Recibe recordatorios importantes en tu correo electrónico.</p>
    </div>
    <div class="feature">
      <img src="https://img.icons8.com/color/96/combo-chart--v1.png" alt="Seguimiento">
      <h3>Panel de Seguimiento</h3>
      <p>Visualiza el progreso de tus proyectos en gráficos claros.</p>
    </div>
  </section>

  <!-- Footer -->
  <footer>
    <p>© 2025 AcadFlow. Todos los derechos reservados.</p>
    <p>Contacto: soporte@acadflow.com</p>
    <p>Desarrollado por: Jose Alejandro Fagua y Heriberto Perez</p>
  </footer>

</body>
</html>