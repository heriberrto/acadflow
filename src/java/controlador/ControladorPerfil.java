package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import modelo.Perfil;
import modelo.PerfilDAO;

@WebServlet(name = "ControladorPerfil", urlPatterns = {"/ControladorPerfil"})
public class ControladorPerfil extends HttpServlet {

    private final PerfilDAO dao = new PerfilDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp");
            return;
        }
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if (accion == null || accion.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp");
            return;
        }

        try {
            switch (accion) {
                case "registrar":
                    registrarPerfil(request, response);
                    break;
                case "editar":
                    editarPerfil(request, response);
                    break;
                case "eliminar":
                    eliminarPerfil(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&error=general");
        }
    }

    // ==============================
    // MÉTODOS AUXILIARES
    // ==============================

    private void registrarPerfil(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Perfil p = new Perfil();
        p.setNombrePerfil(request.getParameter("nombrePerfil"));
        p.setDescripcion(request.getParameter("descripcion"));

        boolean ok = dao.registrarPerfil(p);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&msg=registrado");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&error=registro");
        }
    }

    private void editarPerfil(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Perfil p = new Perfil();
        p.setIdPerfil(Integer.parseInt(request.getParameter("idPerfil")));
        p.setNombrePerfil(request.getParameter("nombrePerfil"));
        p.setDescripcion(request.getParameter("descripcion"));

        boolean ok = dao.actualizarPerfil(p);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&msg=actualizado");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&error=actualizar");
        }
    }

    private void eliminarPerfil(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("idPerfil"));
        boolean ok = dao.eliminarPerfil(id);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&msg=eliminado");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?page=admin/GestionDePerfiles.jsp&error=eliminar");
        }
    }
}
