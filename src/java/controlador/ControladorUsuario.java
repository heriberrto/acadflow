package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import modelo.Usuario;
import modelo.UsuarioDAO;

@WebServlet(name = "ControladorUsuario", urlPatterns = {"/controladorUsuario"})
public class ControladorUsuario extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String rol = request.getParameter("rol");
        String password = request.getParameter("password");
        String confirmar = request.getParameter("confirmar");

        System.out.println("📥 Datos recibidos del formulario:");
        System.out.println("Nombre: " + nombre);
        System.out.println("Apellido: " + apellido);
        System.out.println("Correo: " + correo);
        System.out.println("Rol: " + rol);
        System.out.println("Contraseña: " + password);

        if (nombre == null || correo == null || rol == null || password == null || apellido == null) {
            System.out.println("⚠️ Faltan datos obligatorios.");
            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmar)) {
            System.out.println("❌ Las contraseñas no coinciden");
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombres(nombre);
        nuevo.setApellidos(apellido);
        nuevo.setCorreo(correo);
        nuevo.setRol(rol);
        nuevo.setClave(password);

        boolean registrado = usuarioDAO.registrarUsuario(nuevo);

        if (registrado) {
            System.out.println("✅ Registro exitoso para " + rol + ": " + correo);
            request.setAttribute("mensaje", "Registro exitoso. Ya puedes iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            System.out.println("❌ Error al registrar usuario en la BD");
            request.setAttribute("error", "Error al registrar usuario. Intenta nuevamente.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
