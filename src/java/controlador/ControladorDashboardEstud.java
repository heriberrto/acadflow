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
import java.util.List;
import modelo.Proyectos;
import modelo.ProyectosDAO;
import modelo.Tarea;
import modelo.TareaDAO;

/**
 *
 * @author Mr_Fagua
 */

public class ControladorDashboardEstud extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idUsuario = (int) request.getSession().getAttribute("id");

        // Obtener tareas y proyectos
        TareaDAO tareaDAO = new TareaDAO();
        List<Tarea> misTareas = tareaDAO.listarMisTareas(idUsuario);

        ProyectosDAO proyectoDAO = new ProyectosDAO();
        List<Proyectos> misProyectos = proyectoDAO.listarProyectosPorUsuario(idUsuario);

        // Pasar al JSP
        request.setAttribute("misTareas", misTareas);
        request.setAttribute("misProyectos", misProyectos);

        // Forward al JSP
        request.getRequestDispatcher("dashboard.jsp?page=estudiantePages/dashboard.jsp").forward(request, response);
    }
}
