package modelo;

import java.sql.*;
import java.util.*;

public class TareaDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Listar tareas por proyecto (incluye nombre del responsable)
    public List<Tarea> listarPorProyecto(int idProyecto) {
        List<Tarea> lista = new ArrayList<>();
        String sql = """
            SELECT t.*, u.nombres AS nombreResponsable
            FROM tareas t
            LEFT JOIN usuarios u ON t.asignadoA = u.idUsuario
            WHERE t.idProyecto = ?
            ORDER BY 
                CASE t.estado 
                    WHEN 'pendiente' THEN 1
                    WHEN 'en progreso' THEN 2
                    WHEN 'en revisión' THEN 3
                    WHEN 'completada' THEN 4
                END;
        """;

        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idProyecto);
            rs = ps.executeQuery();
            while (rs.next()) {
                Tarea t = new Tarea();
                t.setIdTarea(rs.getInt("idTarea"));
                t.setTitulo(rs.getString("titulo"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setPrioridad(rs.getString("prioridad"));
                t.setEstado(rs.getString("estado"));
                t.setFechaCreacion(rs.getDate("fechaCreacion"));
                t.setFechaInicio(rs.getDate("fechaInicio"));
                t.setFechaLimite(rs.getDate("fechaLimite"));
                t.setFechaFinalizacion(rs.getDate("fechaFinalizacion"));
                t.setIdProyecto(rs.getInt("idProyecto"));
                t.setAsignadoA(rs.getInt("asignadoA"));
                t.setNombreResponsable(rs.getString("nombreResponsable"));
                lista.add(t);
            }
        } catch (Exception e) {
            System.out.println("Error al listar tareas: " + e.getMessage());
        }
        return lista;
    }

    public boolean actualizarEstado(int idTarea, String nuevoEstado) {
        String sql = "UPDATE tareas SET estado=? WHERE idTarea=?";
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idTarea);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al actualizar estado: " + e.getMessage());
        }
        return false;
    }

    // Crear una nueva tarea
    public boolean crearTarea(Tarea t) {
        String sql = "INSERT INTO tareas (titulo, descripcion, prioridad, estado, idProyecto) VALUES (?, ?, ?, 'pendiente', ?)";
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, t.getTitulo());
            ps.setString(2, t.getDescripcion());
            ps.setString(3, t.getPrioridad());
            ps.setInt(4, t.getIdProyecto());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al crear tarea: " + e.getMessage());
        }
        return false;
    }

// Asignar tarea a un usuario
    public boolean asignarTarea(int idTarea, int idUsuario) {
        String sql = "UPDATE tareas SET asignadoA = ?, estado = 'Pendiente' WHERE idTarea = ?";
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setInt(2, idTarea);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al asignar tarea: " + e.getMessage());
        }
        return false;
    }

// Liberar tarea (quitar asignación)
    public boolean liberarTarea(int idTarea) {
        String sql = "UPDATE tareas SET asignadoA = NULL, estado = 'pendiente' WHERE idTarea = ?";
        try {
            con = cn.crearConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idTarea);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("Error al liberar tarea: " + e.getMessage());
        }
        return false;
    }

// Listar todas las tareas asignadas a un usuario en cualquier proyecto
public List<Tarea> listarMisTareas(int idUsuario) {
    List<Tarea> lista = new ArrayList<>();
    String sql = """
        SELECT t.*, u.nombres AS nombreResponsable, p.nombreProyecto
        FROM tareas t
        LEFT JOIN usuarios u ON t.asignadoA = u.idUsuario
        JOIN proyectos p ON t.idProyecto = p.idProyecto
        WHERE t.asignadoA = ?
        ORDER BY 
            CASE t.estado 
                WHEN 'pendiente' THEN 1
                WHEN 'en progreso' THEN 2
                WHEN 'en revisión' THEN 3
                WHEN 'completada' THEN 4
            END;
    """;

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setInt(1, idUsuario);
        rs = ps.executeQuery();
        while (rs.next()) {
            Tarea t = new Tarea();
            t.setIdTarea(rs.getInt("idTarea"));
            t.setTitulo(rs.getString("titulo"));
            t.setDescripcion(rs.getString("descripcion"));
            t.setPrioridad(rs.getString("prioridad"));
            t.setEstado(rs.getString("estado"));
            t.setFechaCreacion(rs.getDate("fechaCreacion"));
            t.setFechaInicio(rs.getDate("fechaInicio"));
            t.setFechaLimite(rs.getDate("fechaLimite"));
            t.setFechaFinalizacion(rs.getDate("fechaFinalizacion"));
            t.setIdProyecto(rs.getInt("idProyecto"));
            t.setAsignadoA(rs.getInt("asignadoA"));
            t.setNombreResponsable(rs.getString("nombreResponsable"));
            t.setNombreProyecto(rs.getString("nombreProyecto"));
            lista.add(t);
        }
    } catch (Exception e) {
        System.out.println("Error al listar mis tareas: " + e.getMessage());
    }
    return lista;
}


// Contar todas las tareas de un proyecto
public int contarTareasPorProyecto(int idProyecto) {
    String sql = "SELECT COUNT(*) AS total FROM tareas WHERE idProyecto = ?";
    int total = 0;

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setInt(1, idProyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            total = rs.getInt("total");
        }
    } catch (SQLException e) {
        System.out.println("Error contando tareas totales: " + e.getMessage());
    } finally {
        try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch (SQLException e) {}
    }

    return total;
}

// Contar tareas completadas de un proyecto
public int contarTareasCompletadasPorProyecto(int idProyecto) {
    String sql = "SELECT COUNT(*) AS completadas FROM tareas WHERE idProyecto = ? AND estado = 'completada'";
    int completadas = 0;

    try {
        con = cn.crearConexion();
        ps = con.prepareStatement(sql);
        ps.setInt(1, idProyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            completadas = rs.getInt("completadas");
        }
    } catch (SQLException e) {
        System.out.println("Error contando tareas completadas: " + e.getMessage());
    } finally {
        try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch (SQLException e) {}
    }

    return completadas;
}


}
