/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Heriberto
 */
public class ProyectosDAO {

    Conexion cn = new Conexion();

    public boolean registrarProyecto(Proyectos p) {
        Connection con = null;
        PreparedStatement ps = null;
        boolean exito = false;

        try {
            con = cn.crearConexion();
            if (con == null) {
                System.out.println("❌ No se pudo conectar a la base de datos");
                return false;
            }

            String sql = "INSERT INTO proyectos (nombreProyecto, descripcion, fechaInicio, fechaFinal, creadoPor) VALUES (?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getNombreProyecto());
            ps.setString(2, p.getDescripcion());
            ps.setDate(3, new java.sql.Date(p.getFechaInicio().getTime()));
            ps.setDate(4, new java.sql.Date(p.getFechaFinal().getTime()));
            ps.setInt(5, p.getCreadoPor());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                exito = true;
                System.out.println("✅ proyecto registrado correctamente");
            }

        } catch (SQLException ex) {
            System.out.println("❌ Error SQL al crear proyecto: " + ex.getMessage());
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("⚠️ Error cerrando conexión: " + ex.getMessage());
            }
        }
        return exito;
    }

    public boolean asignarProyectoAEquipo(int idProyecto, int idEquipo){
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean exito = false;
        
        try{
            con = cn.crearConexion();
            if(con == null){
                System.out.println("❌ No se pudo conectar a la base de datos");
                return false;
            }
            
            String sql = "INSERT INTO proyectosequipos (idProyecto, idEquipo) VALUES (?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idProyecto);
            ps.setInt(2, idEquipo);
            
            int filas = ps.executeUpdate();
            if(filas>0){
                exito = true;
                System.out.println("✅ Proyecto asignado correctamente");
            }
        }catch(SQLException ex){
            System.out.println("⚠️ Error cerrando conexión: " + ex.getMessage());
        }
        
        return exito;
    }
    
    public List<Proyectos> ListarProyectos() {
        List<Proyectos> lista = new ArrayList<>();
        String sql = "SELECT * FROM proyectos";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Proyectos p = new Proyectos();
                p.setIdProyecto(rs.getInt("idProyecto"));
                p.setNombreProyecto(rs.getString("nombreProyecto"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setFechaInicio(rs.getDate("fechaInicio"));
                p.setFechaFinal(rs.getDate("fechaFinal"));
                p.setCreadoPor(rs.getInt("creadoPor"));
                lista.add(p);
            }

        } catch (SQLException ex) {
            System.out.println("❌ Error al listar equipos: " + ex.getMessage());
        }
        return lista;
    }

    public List<Proyectos> listarProyectosPorUsuario(int idUsuario) {
        List<Proyectos> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = cn.crearConexion();

            // 1️⃣ Primero obtenemos el perfil del usuario (admin, docente o estudiante)
            String sqlPerfil = "SELECT p.nombrePerfil FROM Usuarios u JOIN Perfiles p ON u.idPerfil = p.idPerfil WHERE u.idUsuario = ?";
            ps = con.prepareStatement(sqlPerfil);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            String perfil = "";
            if (rs.next()) {
                perfil = rs.getString("nombrePerfil");
            }

            // Cerramos antes de reutilizar
            rs.close();
            ps.close();

            // 2️⃣ Dependiendo del perfil, aplicamos la consulta correspondiente
            String sql = "";
            if (perfil.equalsIgnoreCase("admin")) {
                // Admin ve todos los proyectos
                sql = "SELECT * FROM Proyectos";
                ps = con.prepareStatement(sql);

            } else if (perfil.equalsIgnoreCase("docente")) {
                // Docente solo los que él creó
                sql = "SELECT * FROM Proyectos WHERE creadoPor = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, idUsuario);

            } else {
                // Estudiante: los proyectos de los equipos a los que pertenece
                sql = """
            SELECT DISTINCT p.*
            FROM Proyectos p
            JOIN ProyectosEquipos pe ON p.idProyecto = pe.idProyecto
            JOIN Equipos e ON pe.idEquipo = e.idEquipo
            JOIN UsuariosEquipos ue ON e.idEquipo = ue.idEquipo
            WHERE ue.idUsuario = ?
            """;
                ps = con.prepareStatement(sql);
                ps.setInt(1, idUsuario);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Proyectos p = new Proyectos();
                p.setIdProyecto(rs.getInt("idProyecto"));
                p.setNombreProyecto(rs.getString("nombreProyecto"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setFechaInicio(rs.getDate("fechaInicio"));
                p.setFechaFinal(rs.getDate("fechaFinal"));
                p.setCreadoPor(rs.getInt("creadoPor"));
                lista.add(p);
            }

        } catch (SQLException ex) {
            System.out.println("❌ Error al listar proyectos del usuario: " + ex.getMessage());
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                System.out.println("⚠️ Error cerrando conexión: " + ex.getMessage());
            }
        }

        return lista;
    }

    public Map<Integer, int[]> listarProyectosConTareas(int idUsuario) {
        Map<Integer, int[]> proyectoTareas = new HashMap<>(); // key=idProyecto, value=[total, completadas]
        List<Proyectos> proyectos = listarProyectosPorUsuario(idUsuario); // reutiliza tu método actual
        TareaDAO tareasDAO = new TareaDAO(); // tu DAO de tareas

        for (Proyectos p : proyectos) {
            int idProyecto = p.getIdProyecto();
            int total = tareasDAO.contarTareasPorProyecto(idProyecto);
            int completadas = tareasDAO.contarTareasCompletadasPorProyecto(idProyecto);

            proyectoTareas.put(idProyecto, new int[]{total, completadas});
        }
        

        return proyectoTareas;
    }
    
    public List<Proyectos> listarProyectosAsignadosAEstudiante(int idUsuario) {
    List<Proyectos> lista = new ArrayList<>();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = cn.crearConexion();

        // 🔹 Consulta SQL basada en tu estructura real:
        String sql = """
            SELECT DISTINCT p.*
            FROM Proyectos p
            INNER JOIN ProyectosEquipos pe ON p.idProyecto = pe.idProyecto
            INNER JOIN UsuariosEquipos ue ON ue.idEquipo = pe.idEquipo
            WHERE ue.idUsuario = ?
        """;

        ps = con.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();

        while (rs.next()) {
            Proyectos p = new Proyectos();
            p.setIdProyecto(rs.getInt("idProyecto"));
            p.setNombreProyecto(rs.getString("nombreProyecto"));
            p.setDescripcion(rs.getString("descripcion"));
            p.setFechaInicio(rs.getDate("fechaInicio"));
            p.setFechaFinal(rs.getDate("fechaFinal"));
            p.setCreadoPor(rs.getInt("creadoPor"));
            lista.add(p);
        }

    } catch (SQLException e) {
        System.out.println("⚠️ Error al listar proyectos asignados al estudiante: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException ex) {
            System.out.println("⚠️ Error cerrando conexión: " + ex.getMessage());
        }
    }

    return lista;
}
    
    
    
    
}
