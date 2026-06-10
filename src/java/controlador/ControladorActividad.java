package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import modelo.ActividadDAO;
import modelo.Actividad;

@WebServlet(name = "ControladorActividad", urlPatterns = {"/ControladorActividad"})
public class ControladorActividad extends HttpServlet {

    private final ActividadDAO dao = new ActividadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp");
            return;
        }
        doPost(request, response); // delega en doPost
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null || accion.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp");
            return;
        }

        try {
            switch (accion) {
                case "registrar":
                    registrarActividad(request, response);
                    break;
                case "eliminar":
                    eliminarActividad(request, response);
                    break;
                case "asignarRol":
                case "revocarRol":
                    asignarORevocarRol(request, response);
                    break;
                case "asignarUsuario":
                case "revocarUsuario":
                    asignarORevocarUsuario(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp");
            }
        } catch (NumberFormatException nfe) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?error=parametros");
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?error=general");
        }
    }

    // ==========================================
    // MÉTODOS AUXILIARES
    // ==========================================

    private void registrarActividad(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Actividad a = new Actividad();
        a.setNombreActividad(request.getParameter("nombre"));
        a.setEnlace(request.getParameter("enlace"));
        a.setIcono(request.getParameter("icono"));

        boolean ok = dao.registrarActividad(a);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=registrada");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?error=registro");
        }
    }

    private void eliminarActividad(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("idActividad");
        if (idStr == null) idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);

        boolean ok = dao.eliminarActividad(id);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=eliminada");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?error=eliminar");
        }
    }

    private void asignarORevocarRol(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int idActividad = Integer.parseInt(request.getParameter("idActividad"));
        int idPerfil = Integer.parseInt(request.getParameter("idPerfil"));

        if (dao.tieneActividadAsignadaARol(idActividad, idPerfil)) {
            dao.revocarActividadARol(idActividad, idPerfil);
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=rolRevocado");
        } else {
            dao.asignarActividadARol(idActividad, idPerfil);
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=rolAsignado");
        }
    }

    private void asignarORevocarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int idActividad = Integer.parseInt(request.getParameter("idActividad"));
        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));

        if (dao.tieneActividadAsignadaAUsuario(idActividad, idUsuario)) {
            dao.revocarActividadAUsuario(idActividad, idUsuario);
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=usuarioRevocado");
        } else {
            dao.asignarActividadAUsuario(idActividad, idUsuario);
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestioActividades.jsp?msg=usuarioAsignado");
        }
    }
}
