package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import modelo.*;

public class ControladorMisTareas extends HttpServlet {

    TareaDAO dao = new TareaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idUsuario = (int) request.getSession().getAttribute("id");
        List<Tarea> misTareas = dao.listarMisTareas(idUsuario);

        request.setAttribute("misTareas", misTareas);
        request.getRequestDispatcher("dashboard.jsp?page=estudiantePages/MisTareas.jsp")
               .forward(request, response);
    }
}
