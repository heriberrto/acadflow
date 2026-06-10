package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.*;

public class ControladorTareas extends HttpServlet {

    TareaDAO dao = new TareaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listarTareasPorProyecto".equals(accion)) {

            int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));
            List<Tarea> tareas = dao.listarPorProyecto(idProyecto);

            // Guardamos datos en el request
            request.setAttribute("tareas", tareas);
            request.setAttribute("idProyecto", idProyecto);

            // ✅ Cargar dentro del dashboard
            request.getRequestDispatcher("dashboard.jsp?page=estudiantePages/TareasPorProyecto.jsp")
                    .forward(request, response);

        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("actualizarEstado".equals(accion)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            String nuevoEstado = request.getParameter("nuevoEstado");
            int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));
            dao.actualizarEstado(idTarea, nuevoEstado);
            response.sendRedirect("ControladorTareas?accion=listarTareasPorProyecto&idProyecto=" + idProyecto);

        } else if ("crearTarea".equals(accion)) {
            Tarea t = new Tarea();
            t.setTitulo(request.getParameter("titulo"));
            t.setDescripcion(request.getParameter("descripcion"));
            t.setPrioridad(request.getParameter("prioridad"));
            t.setIdProyecto(Integer.parseInt(request.getParameter("idProyecto")));
            dao.crearTarea(t);
            response.sendRedirect("ControladorTareas?accion=listarTareasPorProyecto&idProyecto=" + t.getIdProyecto());

        } else if ("asignarTarea".equals(accion)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));
            int idUsuario = (int) request.getSession().getAttribute("id");
            dao.asignarTarea(idTarea, idUsuario);
            response.sendRedirect("ControladorTareas?accion=listarTareasPorProyecto&idProyecto=" + idProyecto);

        } else if ("liberarTarea".equals(accion)) {
            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));
            dao.liberarTarea(idTarea);
            response.sendRedirect("ControladorTareas?accion=listarTareasPorProyecto&idProyecto=" + idProyecto);
        }
    }

}
