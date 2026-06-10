/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.UsuarioDAO;

/**
 *
 * @author Heriberto
 */
@WebServlet(name = "EditarUsuario", urlPatterns = {"/EditarUsuario"})
public class EditarUsuario extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Detectar si es GET o POST
        String method = request.getMethod();

        if ("GET".equalsIgnoreCase(method)) {
            // 🟦 1️⃣ Lógica para mostrar formulario (GET)
            int id = Integer.parseInt(request.getParameter("id"));
            UsuarioDAO udao = new UsuarioDAO();
            Usuario usuario = udao.buscarUsuarioPorId(id);

            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("asignacionesPages/ModificarUsuarios.jsp").forward(request, response);

        } else if ("POST".equalsIgnoreCase(method)) {
            // 🟩 2️⃣ Lógica para actualizar usuario (POST)
            int id = Integer.parseInt(request.getParameter("id"));
            String email = request.getParameter("cmail");
            String nombre = request.getParameter("cnombre");
            String apellido = request.getParameter("capellido");
            String clave = request.getParameter("cclave");

            /*Usuario u = new Usuario();
            
            
            u.setId(id);
            u.setCorreo(email);
            u.setNombres(nombre);
            u.setApellidos(apellido);
            u.setClave(clave);

            UsuarioDAO udao = new UsuarioDAO();
            int status = udao.actualizarUsuario(u);

            if (status > 0) {
                response.sendRedirect("asignacionesPages/ListaUsuarios.jsp");
            } else {
                response.getWriter().println("❌ Error al actualizar usuario");
            }*/
            
            UsuarioDAO udao = new UsuarioDAO();

            // 🔹 Recupera el usuario actual con su rol
            Usuario usuarioExistente = udao.buscarUsuarioPorId(id);
            if (usuarioExistente == null) {
                response.getWriter().println("❌ Usuario no encontrado");
                return;
            }

            // 🔹 Actualiza solo los campos modificables
            usuarioExistente.setCorreo(email);
            usuarioExistente.setNombres(nombre);
            usuarioExistente.setApellidos(apellido);
            //usuarioExistente.setClave(clave);
            
            if (clave != null && !clave.trim().isEmpty()) {
                usuarioExistente.setClave(clave);
            }

            int status = udao.actualizarUsuario(usuarioExistente);

            if (status > 0) {
                //response.sendRedirect("dashboard.jsp?page=docentePages/ModificarEstudiantes.jsp");
                String referer = request.getHeader("referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    // En caso de que no haya cabecera referer
                    response.sendRedirect("dashboard.jsp?page=docentePages/ModificarEstudiantes.jsp");
                }
            } else {
                response.getWriter().println("❌ Error al actualizar usuario");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}