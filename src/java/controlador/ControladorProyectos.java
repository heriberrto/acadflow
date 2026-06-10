package controlador;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import modelo.ProyectosDAO;
import modelo.Proyectos;
import modelo.TareaDAO;

@WebServlet(name = "ControladorProyectos", urlPatterns = {"/ControladorProyectos"})
public class ControladorProyectos extends HttpServlet {

    private final ProyectosDAO proyectosDAO = new ProyectosDAO();
    private final TareaDAO tareaDAO = new TareaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("crearProyecto".equalsIgnoreCase(accion)) {
            registrarProyecto(request, response);
        }else if("agregarEquipo".equalsIgnoreCase(accion)){
            agregarEquipo(request, response);
        } else {
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("listarMisProyectos".equalsIgnoreCase(accion)) {
            listarMisProyectos(request, response);
        } else {
            response.sendRedirect("error.jsp");
        }
    }

    private void listarMisProyectos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener ID del usuario desde la sesión
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("idUsuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int idUsuario = (int) sesion.getAttribute("idUsuario");
    String rol = (String) sesion.getAttribute("rol"); // ← asegúrate de guardar esto al iniciar sesión

    List<Proyectos> misProyectos;

    // 🔹 Selecciona qué método DAO usar según el rol
    if ("docente".equalsIgnoreCase(rol)) {
        misProyectos = proyectosDAO.listarProyectosPorUsuario(idUsuario);
    } else if ("estudiante".equalsIgnoreCase(rol)) {
        misProyectos = proyectosDAO.listarProyectosAsignadosAEstudiante(idUsuario);
    } else {
        misProyectos = List.of(); // lista vacía para otros roles
    }

    // 🔹 Mapas para tareas por proyecto
    Map<Integer, Integer> totalTareasPorProyecto = new HashMap<>();
    Map<Integer, Integer> tareasCompletadasPorProyecto = new HashMap<>();

    for (Proyectos p : misProyectos) {
        int total = tareaDAO.contarTareasPorProyecto(p.getIdProyecto());
        int completadas = tareaDAO.contarTareasCompletadasPorProyecto(p.getIdProyecto());

        totalTareasPorProyecto.put(p.getIdProyecto(), total);
        tareasCompletadasPorProyecto.put(p.getIdProyecto(), completadas);
    }

    // 🔹 Enviar datos al JSP
    request.setAttribute("misProyectos", misProyectos);
    request.setAttribute("totalTareasPorProyecto", totalTareasPorProyecto);
    request.setAttribute("tareasCompletadasPorProyecto", tareasCompletadasPorProyecto);

    request.getRequestDispatcher("dashboard.jsp?page=estudiantePages/MisProyectos.jsp")
           .forward(request, response);
    }

    private void registrarProyecto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombreProyecto = request.getParameter("nombreProyecto");
        String descripcion = request.getParameter("descripcion");
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinalStr = request.getParameter("fechaLimite");
        //String creadoPorStr = request.getParameter("creadoPor");

        if (nombreProyecto == null || descripcion == null || fechaInicioStr == null
                || fechaFinalStr == null) {
            request.setAttribute("error", "Faltan datos del proyecto.");
            //request.getRequestDispatcher("registrarEquipo.jsp").forward(request, response);
            return;
        }

        HttpSession sesion = request.getSession(false);
        if(sesion == null || sesion.getAttribute("idUsuario")==null){
            request.setAttribute("error", "Sesión no válida o usuario no autenticado.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        //int IdCreador = Integer.parseInt(creadoPorStr);
        int IdCreador = (int) sesion.getAttribute("idUsuario");

        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaInicio, fechaFinal;

        try {
            fechaInicio = formato.parse(fechaInicioStr);
            fechaFinal = formato.parse(fechaFinalStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Formato de fecha inválido.");
            //request.getRequestDispatcher("registrarEquipo.jsp").forward(request, response);
            return;
        }

        Proyectos proyecto = new Proyectos();
        proyecto.setNombreProyecto(nombreProyecto);
        proyecto.setDescripcion(descripcion);
        proyecto.setFechaInicio(fechaInicio);
        proyecto.setFechaFinal(fechaFinal);
        proyecto.setCreadoPor(IdCreador);

        boolean registrado = proyectosDAO.registrarProyecto(proyecto);

        if (registrado) {
            request.setAttribute("mensaje", "✅ Proyecto registrado correctamente.");
        } else {
            request.setAttribute("error", "❌ Error al registrar el proyecto.");
        }

        request.getRequestDispatcher("dashboard.jsp?page=docentePages/proyectodocente.jsp").forward(request, response);
    }
    private void agregarEquipo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try{
            int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));
            int idEquipo = Integer.parseInt(request.getParameter("idEquipo"));
            
            boolean agregado = proyectosDAO.asignarProyectoAEquipo(idProyecto,idEquipo);
            
           
            
            if(agregado){
                request.setAttribute("mensaje", "✅ Proyecto asignado correctamente al equipo.");
            }else{
                request.setAttribute("error", "❌ No se pudo agregar el equipo.");
            }
            
            request.getRequestDispatcher("dashboard.jsp?page=docentePages/proyectodocente.jsp").forward(request, response);
        }catch(NumberFormatException e) {
            request.setAttribute("error", "Datos inválidos.");
            //request.getRequestDispatcher("proyectodocente.jsp").forward(request, response);
        }
    }
}
