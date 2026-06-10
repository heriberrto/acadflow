package controlador;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import modelo.Equipo;
import modelo.EquipoDAO;
import modelo.Usuario;
import modelo.UsuarioDAO;

@WebServlet(name = "ControladorEquipo", urlPatterns = {"/ControladorEquipo"})
public class ControladorEquipo extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    private final EquipoDAO equipoDAO = new EquipoDAO();

    // ===========================
    // 🔹 MÉTODO GET
    // ===========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try {
            if ("listarEquipos".equalsIgnoreCase(accion)) {
                List<Equipo> equipos = equipoDAO.listarEquipos();

                // 🔹 Nueva línea: obtener todos los docentes
                List<Usuario> docentes = usuarioDAO.listarPorRol("docente");

                // 🔹 Enviar ambas listas a la vista
                request.setAttribute("equipos", equipos);
                request.setAttribute("docentes", docentes);

                // 🔹 Redirigir a la página JSP
                request.getRequestDispatcher("dashboard.jsp?page=docentePages/GestionEquipos.jsp")
                        .forward(request, response);

            } else if ("verIntegrantes".equalsIgnoreCase(accion)) {
                int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));
                List<Usuario> integrantes = equipoDAO.listarIntegrantesEquipo(idEquipo);

                // 🔹 Listar todos los estudiantes para el modal
                List<Usuario> estudiantes = usuarioDAO.listarPorRol("estudiante");

                request.setAttribute("integrantes", integrantes);
                request.setAttribute("estudiantes", estudiantes);
                request.setAttribute("idEquipo", idEquipo);

                request.getRequestDispatcher("dashboard.jsp?page=docentePages/VerIntegrantesEquipo.jsp")
                        .forward(request, response);
            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    // ===========================
    // 🔹 MÉTODO POST
    // ===========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try {
            if ("registrar".equalsIgnoreCase(accion)) {
                registrarEquipo(request, response);

            } else if ("agregarEstudiante".equalsIgnoreCase(accion)) {
                agregarEstudiante(request, response);

            } else if ("eliminar".equalsIgnoreCase(accion)) {
                eliminarEquipo(request, response);

            } else if ("agregarIntegrante".equalsIgnoreCase(accion)) {
                agregarIntegrante(request, response);

            } else if ("eliminarIntegrante".equalsIgnoreCase(accion)) {
                eliminarIntegrante(request, response);

            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

// ===========================
// 🔹 REGISTRAR EQUIPO
// ===========================
    private void registrarEquipo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreEquipo = request.getParameter("nombreEquipo");
        String idDocenteStr = request.getParameter("idDocente");

        if (nombreEquipo == null || idDocenteStr == null) {
            response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=error");
            return;
        }

        int idDocente = Integer.parseInt(idDocenteStr);
        Equipo equipo = new Equipo();
        equipo.setNombreEquipo(nombreEquipo);
        equipo.setIdDocente(idDocente);

        boolean registrado = equipoDAO.registrarEquipo(equipo);

        if (registrado) {
            // 🔹 Redirigir al servlet para listar equipos con mensaje de éxito
            response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=ok");
        } else {
            // 🔹 Redirigir con mensaje de error
            response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=error");
        }
    }

    // ===========================
    // 🔹 AGREGAR ESTUDIANTE (versión básica)
    // ===========================
    private void agregarEstudiante(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idEstudiante = Integer.parseInt(request.getParameter("idUsuario"));
            int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));

            boolean agregado = equipoDAO.agregarEstudianteAEquipo(idEstudiante, idEquipo);

            if (agregado) {
                request.setAttribute("mensaje", "✅ Estudiante agregado correctamente al equipo.");
            } else {
                request.setAttribute("error", "❌ No se pudo agregar el estudiante.");
            }

            request.getRequestDispatcher("asignacionesPages/CreacionEquiposDocente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Datos inválidos.");
            request.getRequestDispatcher("agregarEstudianteEquipo.jsp").forward(request, response);
        }
    }

// ===========================
// 🔹 ELIMINAR EQUIPO
// ===========================
    private void eliminarEquipo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));
            boolean eliminado = equipoDAO.eliminarEquipo(idEquipo);

            if (eliminado) {
                // Redirigir igual que registrar
                response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=eliminado_ok");
            } else {
                response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=eliminado_error");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("ControladorEquipo?accion=listarEquipos&mensaje=eliminado_error");
        }
    }

    // ===========================
    // 🔹 AGREGAR INTEGRANTE (desde el modal)
    // ===========================
    private void agregarIntegrante(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));

        boolean ok = equipoDAO.agregarEstudianteAEquipo(idUsuario, idEquipo);
        response.sendRedirect("ControladorEquipo?accion=verIntegrantes&idEquipo=" + idEquipo);
    }

    // ===========================
    // 🔹 ELIMINAR INTEGRANTE
    // ===========================
    private void eliminarIntegrante(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
        int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));

        boolean eliminado = equipoDAO.eliminarIntegrante(idUsuario, idEquipo);

        if (eliminado) {
            System.out.println("✅ Integrante eliminado correctamente del equipo " + idEquipo);
        } else {
            System.out.println("⚠️ No se pudo eliminar el integrante del equipo " + idEquipo);
        }

        // Redirige nuevamente a la vista de integrantes del equipo
        response.sendRedirect("ControladorEquipo?accion=verIntegrantes&idEquipo=" + idEquipo);
    }
}
