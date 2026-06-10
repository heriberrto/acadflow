package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    private final Conexion cn = new Conexion();

    /**
     * Registra un nuevo usuario en la tabla unificada "Usuarios".
     */
    public boolean registrarUsuario(Usuario u) {
        Connection con = null;
        PreparedStatement ps = null;
        boolean exito = false;

        try {
            con = cn.crearConexion();
            if (con == null) {
                System.out.println("❌ No se pudo conectar a la base de datos");
                return false;
            }

            // Obtener el idPerfil según el rol
            int idPerfil = obtenerIdPerfil(u.getRol(), con);
            if (idPerfil == -1) {
                System.out.println("⚠️ No se encontró el perfil para el rol: " + u.getRol());
                return false;
            }

            String sql = "INSERT INTO Usuarios (correo, nombres, apellidos, password, idPerfil, activo) VALUES (?, ?, ?, ?, ?, TRUE)";
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getCorreo());
            ps.setString(2, u.getNombres());
            ps.setString(3, u.getApellidos());
            ps.setString(4, u.getClave());
            ps.setInt(5, idPerfil);

            int filas = ps.executeUpdate();
            if (filas > 0) {
                exito = true;
                System.out.println("✅ Usuario registrado correctamente con rol: " + u.getRol());
            }

        } catch (SQLException e) {
            System.out.println("❌ Error SQL al registrar usuario: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("❌ Error general en registrarUsuario: " + e.getMessage());
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

    /**
     * Obtiene el ID del perfil según el nombre del rol.
     */
    private int obtenerIdPerfil(String rol, Connection con) throws SQLException {
        String sql = "SELECT idPerfil FROM Perfiles WHERE nombrePerfil = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, rol.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idPerfil");
                }
            }
        }
        return -1;
    }

    /**
     * Elimina un usuario por su ID.
     */
    public int eliminarUsuario(int id) {
        int estatus = 0;
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement("DELETE FROM Usuarios WHERE idUsuario = ?")) {

            ps.setInt(1, id);
            estatus = ps.executeUpdate();
            System.out.println("🗑️ Usuario eliminado correctamente.");

        } catch (SQLException ex) {
            System.out.println("❌ Error al eliminar el usuario: " + ex.getMessage());
        }
        return estatus;
    }

    /**
     * Busca un usuario por su ID.
     */
    public Usuario buscarUsuarioPorId(int id) {
        Usuario u = null;
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(
                "SELECT u.*, p.nombrePerfil AS rol FROM Usuarios u INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil WHERE idUsuario = ?")) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    u.setId(rs.getInt("idUsuario"));
                    u.setCorreo(rs.getString("correo"));
                    u.setNombres(rs.getString("nombres"));
                    u.setApellidos(rs.getString("apellidos"));
                    u.setClave(rs.getString("password"));
                    u.setRol(rs.getString("rol"));
                }
            }
            System.out.println("🔎 Usuario encontrado correctamente.");

        } catch (SQLException ex) {
            System.out.println("❌ Error al buscar el usuario: " + ex.getMessage());
        }
        return u;
    }

    /**
     * Actualiza los datos de un usuario.
     */
    public int actualizarUsuario(Usuario u) {
        int estatus = 0;
        try (Connection con = cn.crearConexion()) {

            int idPerfil = obtenerIdPerfil(u.getRol(), con);
            if (idPerfil == -1) {
                System.out.println("⚠️ No se encontró el perfil para el rol: " + u.getRol());
                return 0;
            }

            //String sql = "UPDATE Usuarios SET correo=?, nombres=?, apellidos=?, password=? WHERE idUsuario=?";
            String sql;
            if (u.getClave() != null && !u.getClave().trim().isEmpty()) {
                sql = "UPDATE Usuarios SET correo=?, nombres=?, apellidos=?, password=? WHERE idUsuario=?";
            } else {
                sql = "UPDATE Usuarios SET correo=?, nombres=?, apellidos=? WHERE idUsuario=?";
            }
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, u.getCorreo());
                ps.setString(2, u.getNombres());
                ps.setString(3, u.getApellidos());
                ps.setString(4, u.getClave());
                ps.setInt(5, u.getId());

                estatus = ps.executeUpdate();
                System.out.println("✅ Usuario actualizado correctamente.");
            }

        } catch (SQLException ex) {
            System.out.println("❌ Error al actualizar el usuario: " + ex.getMessage());
        }
        return estatus;
    }

    /**
     * Lista todos los usuarios activos junto con su rol.
     */
    public List<Usuario> listarUsuarios() {
        List<Usuario> lista = new ArrayList<>();
        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(
                "SELECT u.idUsuario, u.correo, u.nombres, u.apellidos, p.nombrePerfil AS rol "
                + "FROM Usuarios u INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil WHERE u.activo = TRUE"); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("idUsuario"));
                u.setCorreo(rs.getString("correo"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }

            System.out.println("📋 Lista de usuarios obtenida correctamente.");

        } catch (SQLException ex) {
            System.out.println("❌ Error al listar los usuarios: " + ex.getMessage());
        }
        return lista;
    }

    public List<Usuario> listarEstudiantes() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.idUsuario, u.correo, u.nombres, u.apellidos, p.nombrePerfil AS rol "
                + "FROM Usuarios u INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil "
                + "WHERE u.activo = TRUE AND p.nombrePerfil = 'estudiante'";

        try (Connection con = cn.crearConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("idUsuario"));
                u.setCorreo(rs.getString("correo"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }

            System.out.println("📋 Lista de estudiantes obtenida correctamente.");

        } catch (SQLException ex) {
            System.out.println("❌ Error al listar los estudiantes: " + ex.getMessage());
        }
        return lista;
    }
    
   public List<Usuario> listarDocentesYEstudiantes() {
    List<Usuario> lista = new ArrayList<>();
    String sql = "SELECT u.idUsuario, u.correo, u.nombres, u.apellidos, p.nombrePerfil AS rol "
               + "FROM Usuarios u "
               + "INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil "
               + "WHERE u.activo = TRUE AND u.idPerfil IN (1, 2)";

    try (Connection con = cn.crearConexion();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Usuario u = new Usuario();
            u.setId(rs.getInt("idUsuario"));
            u.setCorreo(rs.getString("correo"));
            u.setNombres(rs.getString("nombres"));
            u.setApellidos(rs.getString("apellidos"));
            u.setRol(rs.getString("rol"));
            lista.add(u);
        }

        System.out.println("📋 Lista de docentes y estudiantes obtenida correctamente.");

    } catch (SQLException ex) {
        System.out.println("❌ Error al listar los usuarios: " + ex.getMessage());
    }

    return lista;
}

   public List<Usuario> listarPorRol(String rol) {
    List<Usuario> lista = new ArrayList<>();
    String sql = "SELECT u.idUsuario, u.correo, u.nombres, u.apellidos, p.nombrePerfil AS rol "
               + "FROM Usuarios u "
               + "INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil "
               + "WHERE p.nombrePerfil = ? AND u.activo = TRUE";

    try (Connection con = cn.crearConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, rol.toLowerCase());
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Usuario u = new Usuario();
            u.setId(rs.getInt("idUsuario"));
            u.setCorreo(rs.getString("correo"));
            u.setNombres(rs.getString("nombres"));
            u.setApellidos(rs.getString("apellidos"));
            u.setRol(rs.getString("rol"));
            lista.add(u);
        }

        System.out.println("📋 Lista de usuarios con rol '" + rol + "' obtenida correctamente.");

    } catch (SQLException ex) {
        System.out.println("❌ Error al listar usuarios por rol: " + ex.getMessage());
    }

    return lista;
}


}
