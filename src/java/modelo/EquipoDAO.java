package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EquipoDAO {

    Conexion cn = new Conexion();

    // ✅ Registrar equipo (docente o admin)
    public boolean registrarEquipo(Equipo e) {
        String sql = "INSERT INTO Equipos (nombreEquipo, idDocente) VALUES (?, ?)";
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, e.getNombreEquipo());
            ps.setInt(2, e.getIdDocente());
            int filas = ps.executeUpdate();
            if (filas > 0) {
                System.out.println("✅ Equipo registrado correctamente");
                return true;
            }
        } catch (SQLException ex) {
            System.out.println("❌ Error SQL al registrar equipo: " + ex.getMessage());
        }
        return false;
    }

    // ✅ Agregar estudiante a un equipo
    public boolean agregarEstudianteAEquipo(int idUsuario, int idEquipo) {
        String verificar = """
            SELECT p.nombrePerfil
            FROM Usuarios u
            JOIN Perfiles p ON u.idPerfil = p.idPerfil
            WHERE u.idUsuario = ?
        """;
        String insertar = "INSERT INTO UsuariosEquipos (idUsuario, idEquipo) VALUES (?, ?)";
        try (Connection con = cn.crearConexion(); PreparedStatement psVer = con.prepareStatement(verificar); PreparedStatement psIns = con.prepareStatement(insertar)) {

            psVer.setInt(1, idUsuario);
            ResultSet rs = psVer.executeQuery();
            if (rs.next()) {
                String perfil = rs.getString("nombrePerfil");
                if (!"estudiante".equalsIgnoreCase(perfil)) {
                    System.out.println("⚠️ El usuario no es estudiante (perfil: " + perfil + ")");
                    return false;
                }
            } else {
                System.out.println("⚠️ Usuario no encontrado con ID: " + idUsuario);
                return false;
            }

            psIns.setInt(1, idUsuario);
            psIns.setInt(2, idEquipo);
            int filas = psIns.executeUpdate();
            return filas > 0;
        } catch (SQLException ex) {
            System.out.println("❌ Error al agregar estudiante al equipo: " + ex.getMessage());
        }
        return false;
    }

    // ✅ Listar todos los equipos con nombre del docente
    public List<Equipo> listarEquipos() {
        List<Equipo> lista = new ArrayList<>();
        String sql = """
            SELECT e.idEquipo, e.nombreEquipo, e.idDocente, 
                   CONCAT(u.nombres, ' ', u.apellidos) AS nombreDocente
            FROM Equipos e
            LEFT JOIN Usuarios u ON e.idDocente = u.idUsuario
        """;

        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Equipo e = new Equipo();
                e.setIdEquipo(rs.getInt("idEquipo"));
                e.setNombreEquipo(rs.getString("nombreEquipo"));
                e.setIdDocente(rs.getInt("idDocente"));
                e.setNombreDocente(rs.getString("nombreDocente"));
                lista.add(e);
            }
        } catch (SQLException ex) {
            System.out.println("❌ Error al listar equipos: " + ex.getMessage());
        }
        return lista;
    }

    // ✅ Listar estudiantes de un equipo específico
    public List<Usuario> listarEstudiantesPorEquipo(int idEquipo) {
        List<Usuario> lista = new ArrayList<>();
        String sql = """
            SELECT u.idUsuario, u.nombres, u.apellidos, u.correo
            FROM UsuariosEquipos ue
            JOIN Usuarios u ON ue.idUsuario = u.idUsuario
            WHERE ue.idEquipo = ?
        """;

        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEquipo);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("idUsuario"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                lista.add(u);
            }
        } catch (SQLException ex) {
            System.out.println("❌ Error al listar estudiantes del equipo: " + ex.getMessage());
        }
        return lista;
    }

    // ✅ Eliminar equipo (y relaciones)
    public boolean eliminarEquipo(int idEquipo) {
        String eliminarUsuarios = "DELETE FROM UsuariosEquipos WHERE idEquipo = ?";
        String eliminarProyectos = "DELETE FROM ProyectosEquipos WHERE idEquipo = ?";
        String eliminarEquipo = "DELETE FROM Equipos WHERE idEquipo = ?";

        try (Connection con = cn.crearConexion()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(eliminarUsuarios); PreparedStatement ps2 = con.prepareStatement(eliminarProyectos); PreparedStatement ps3 = con.prepareStatement(eliminarEquipo)) {

                ps1.setInt(1, idEquipo);
                ps1.executeUpdate();

                ps2.setInt(1, idEquipo);
                ps2.executeUpdate();

                ps3.setInt(1, idEquipo);
                int filas = ps3.executeUpdate();

                con.commit();
                return filas > 0;
            } catch (SQLException e) {
                con.rollback();
                System.out.println("❌ Error en transacción al eliminar equipo: " + e.getMessage());
            }
        } catch (SQLException ex) {
            System.out.println("❌ Error general al eliminar equipo: " + ex.getMessage());
        }
        return false;
    }

    public List<Usuario> listarIntegrantesEquipo(int idEquipo) {
        List<Usuario> integrantes = new ArrayList<>();
        String sql = """
        SELECT u.idUsuario, u.nombres, u.apellidos, u.correo 
        FROM UsuariosEquipos ue
        INNER JOIN Usuarios u ON ue.idUsuario = u.idUsuario
        WHERE ue.idEquipo = ?
    """;

        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idEquipo);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("idUsuario"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                integrantes.add(u);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error al listar integrantes del equipo: " + e.getMessage());
        }

        return integrantes;
    }

    
    public boolean eliminarIntegrante(int idUsuario, int idEquipo) {
    String sql = "DELETE FROM UsuariosEquipos WHERE idUsuario=? AND idEquipo=?";
    try (Connection con = new Conexion().crearConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ps.setInt(2, idEquipo);

        int filas = ps.executeUpdate();
        return filas > 0; // ✅ Devuelve true si se eliminó

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

}
