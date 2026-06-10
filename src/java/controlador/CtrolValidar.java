package controlador;

import modelo.LoginDAO;
import modelo.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "CtrolValidar", urlPatterns = {"/CtrolValidar"})
public class CtrolValidar extends HttpServlet {

    private final LoginDAO loginDAO = new LoginDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [CtrolValidar] Entrando al método doPost ===");

        String accion = request.getParameter("accion");
        String correo = request.getParameter("cusuario");
        String clave = request.getParameter("cclave");

        if (accion == null) {
            System.out.println("⚠️ No se recibió ningún parámetro 'accion' desde el formulario.");
            request.setAttribute("error", "Error interno: parámetro 'accion' no recibido.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if ("Ingresar".equalsIgnoreCase(accion)) {
            System.out.println("Procesando inicio de sesión...");
            Usuario usuario = loginDAO.login(correo, clave);

            if (usuario != null) {
                System.out.println("✅ Usuario autenticado: " + usuario.getCorreo() + " | Rol: " + usuario.getRol());
                System.out.println("Actividades permitidas: " + usuario.getActividades().size());

                HttpSession sesion = request.getSession(true);
                sesion.setAttribute("usuario", usuario);
                sesion.setAttribute("rol", usuario.getRol());
                sesion.setAttribute("nombre", usuario.getNombres());
                sesion.setAttribute("correo", usuario.getCorreo());
                sesion.setAttribute("actividades", usuario.getActividades());
                sesion.setAttribute("id", usuario.getId());
                sesion.setAttribute("idUsuario", usuario.getId());
                // Redirige a un solo dashboard, el cual mostrará dinámicamente los menús permitidos
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);


            } else {
                System.out.println("❌ Credenciales incorrectas para el usuario: " + correo);
                request.setAttribute("error", "Usuario o contraseña incorrectos o usuario inactivo.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            System.out.println("⚠️ Acción desconocida: " + accion);
            request.setAttribute("error", "Acción no reconocida.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador que valida usuarios y carga las actividades permitidas según su rol y permisos.";
    }
}
