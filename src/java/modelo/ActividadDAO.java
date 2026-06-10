package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActividadDAO {

    private final Conexion cn = new Conexion();

    // ======================================
    // LISTAR TODAS LAS ACTIVIDADES
    // ======================================
    public List<Actividad> listarActividades() {
        List<Actividad> lista = new ArrayList<>();
        String sql = "SELECT * FROM Actividades";

        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Actividad a = new Actividad();
                a.setId(rs.getInt("idActividad"));
                a.setNombreActividad(rs.getString("nombreActividad"));
                a.setEnlace(rs.getString("enlace"));
                a.setIcono(rs.getString("icono"));
                lista.add(a);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error al listar actividades: " + e.getMessage());
        }
        return lista;
    }

    // ======================================
    // REGISTRAR NUEVA ACTIVIDAD
    // ======================================
    public boolean registrarActividad(Actividad a) {
        String sql = "INSERT INTO Actividades (nombreActividad, enlace, icono) VALUES (?, ?, ?)";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, a.getNombreActividad());
            ps.setString(2, a.getEnlace());
            ps.setString(3, a.getIcono());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error al registrar actividad: " + e.getMessage());
        }
        return false;
    }

    // ======================================
    // ELIMINAR ACTIVIDAD
    // ======================================
    public boolean eliminarActividad(int idActividad) {
        String sql1 = "DELETE FROM PermisosPerfil WHERE idActividad = ?";
        String sql2 = "DELETE FROM PermisosUsuario WHERE idActividad = ?";
        String sql3 = "DELETE FROM Actividades WHERE idActividad = ?";

        try (Connection con = cn.crearConexion()) {
            con.setAutoCommit(false); // Inicia transacción

            try (PreparedStatement ps1 = con.prepareStatement(sql1); PreparedStatement ps2 = con.prepareStatement(sql2); PreparedStatement ps3 = con.prepareStatement(sql3)) {

                ps1.setInt(1, idActividad);
                ps1.executeUpdate();

                ps2.setInt(1, idActividad);
                ps2.executeUpdate();

                ps3.setInt(1, idActividad);
                int filas = ps3.executeUpdate();

                con.commit();
                return filas > 0;

            } catch (SQLException e) {
                con.rollback();
                System.out.println("❌ Error al eliminar actividad con dependencias: " + e.getMessage());
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al conectar para eliminar actividad: " + e.getMessage());
        }
        return false;
    }

    // ======================================
    // ASIGNAR / REVOCAR ACTIVIDAD A ROL
    // ======================================
    public boolean asignarActividadARol(int idActividad, int idPerfil) {
        String sql = """
                INSERT INTO PermisosPerfil (idPerfil, idActividad, permitido)
                VALUES (?, ?, TRUE)
                ON DUPLICATE KEY UPDATE permitido = TRUE
                """;
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPerfil);
            ps.setInt(2, idActividad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error al asignar actividad a rol: " + e.getMessage());
        }
        return false;
    }

    public boolean revocarActividadARol(int idActividad, int idPerfil) {
        String sql = "UPDATE PermisosPerfil SET permitido = FALSE WHERE idPerfil = ? AND idActividad = ?";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPerfil);
            ps.setInt(2, idActividad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error al revocar actividad del rol: " + e.getMessage());
        }
        return false;
    }

    // ======================================
    // ASIGNAR / REVOCAR ACTIVIDAD A USUARIO
    // ======================================
    public boolean asignarActividadAUsuario(int idActividad, int idUsuario) {
        String sql = """
                INSERT INTO PermisosUsuario (idUsuario, idActividad, permitido, fechaInicio)
                VALUES (?, ?, TRUE, NOW())
                ON DUPLICATE KEY UPDATE permitido = TRUE, fechaFin = NULL
                """;
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idActividad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error al asignar actividad al usuario: " + e.getMessage());
        }
        return false;
    }

    public boolean revocarActividadAUsuario(int idActividad, int idUsuario) {
        String sql = "UPDATE PermisosUsuario SET permitido = FALSE, fechaFin = NOW() WHERE idUsuario = ? AND idActividad = ?";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idActividad);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error al revocar actividad del usuario: " + e.getMessage());
        }
        return false;
    }

    // ======================================
    // CONSULTAS DE VALIDACIÓN VISUAL
    // ======================================
    public boolean tieneActividadAsignadaARol(int idActividad, int idPerfil) {
        String sql = "SELECT permitido FROM PermisosPerfil WHERE idPerfil = ? AND idActividad = ? AND permitido = TRUE";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idPerfil);
            ps.setInt(2, idActividad);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("⚠️ Error al verificar actividad del rol: " + e.getMessage());
        }
        return false;
    }

    public boolean tieneActividadAsignadaAUsuario(int idActividad, int idUsuario) {
        String sql = "SELECT permitido FROM PermisosUsuario WHERE idUsuario = ? AND idActividad = ? AND permitido = TRUE";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idActividad);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("⚠️ Error al verificar actividad del usuario: " + e.getMessage());
        }
        return false;
    }
}
