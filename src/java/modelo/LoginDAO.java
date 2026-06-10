package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoginDAO {
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    public Usuario login(String correo, String password) {
        Usuario usuario = null;
        Conexion cn = new Conexion();

        try {
            conn = cn.crearConexion();

            // Buscar usuario unificado (ya no docente/estudiante por separado)
            String sql = "SELECT u.idUsuario, u.correo, u.nombres, u.apellidos, p.nombrePerfil AS rol " +
                         "FROM Usuarios u " +
                         "INNER JOIN Perfiles p ON u.idPerfil = p.idPerfil " +
                         "WHERE u.correo = ? AND u.password = ? AND u.activo = TRUE";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("idUsuario"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setNombres(rs.getString("nombres"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setRol(rs.getString("rol"));

                // Cargar actividades del usuario (rol + personalizadas)
                usuario.setActividades(getActividadesPorUsuario(usuario.getId()));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
        return usuario;
    }

    private List<Actividad> getActividadesPorUsuario(int idUsuario) throws SQLException {
    List<Actividad> actividades = new ArrayList<>();

    String sql = """
        SELECT DISTINCT a.idActividad, a.nombreActividad, a.enlace, a.icono
        FROM Actividades a
        LEFT JOIN PermisosPerfil pp ON pp.idActividad = a.idActividad
        LEFT JOIN Usuarios u ON u.idPerfil = pp.idPerfil
        LEFT JOIN PermisosUsuario pu ON pu.idActividad = a.idActividad AND pu.idUsuario = u.idUsuario
        WHERE u.idUsuario = ? AND (
            COALESCE(pu.permitido, pp.permitido, FALSE) = TRUE
        )
        ORDER BY a.nombreActividad ASC
    """;

    try (Connection conn = new Conexion().crearConexion();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idUsuario);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Actividad act = new Actividad();
                act.setId(rs.getInt("idActividad"));
                act.setNombreActividad(rs.getString("nombreActividad"));
                act.setIcono(rs.getString("icono"));

                // Si el enlace en la BD es "proyectos", lo transformamos como antes:
                String enlace = rs.getString("enlace");
                if (enlace != null && !enlace.contains("dashboard.jsp")) {
                    enlace = "dashboard.jsp?page=" + enlace;
                }
                act.setEnlace(enlace);

                actividades.add(act);
            }
        }
    }
System.out.println("Actividades cargadas para usuario " + idUsuario + ": " + actividades);

    return actividades;
}

}
