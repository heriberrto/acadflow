package modelo;

import java.sql.*;
import java.util.*;

public class PerfilDAO {
    private final Conexion cn = new Conexion();

    // Listar todos los perfiles
    public List<Perfil> listarPerfiles() {
        List<Perfil> lista = new ArrayList<>();
        String sql = "SELECT * FROM Perfiles";
        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setIdPerfil(rs.getInt("idPerfil"));
                p.setNombrePerfil(rs.getString("nombrePerfil"));
                p.setDescripcion(rs.getString("descripcion"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al listar perfiles: " + e.getMessage());
        }
        return lista;
    }

    // Registrar nuevo perfil
    public boolean registrarPerfil(Perfil p) {
        String sql = "INSERT INTO Perfiles (nombrePerfil, descripcion) VALUES (?, ?)";
        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombrePerfil());
            ps.setString(2, p.getDescripcion());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("❌ Error al registrar perfil: " + e.getMessage());
            return false;
        }
    }

    // Obtener un perfil por ID
    public Perfil obtenerPorId(int id) {
        Perfil p = null;
        String sql = "SELECT * FROM Perfiles WHERE idPerfil=?";
        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Perfil();
                    p.setIdPerfil(rs.getInt("idPerfil"));
                    p.setNombrePerfil(rs.getString("nombrePerfil"));
                    p.setDescripcion(rs.getString("descripcion"));
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener perfil: " + e.getMessage());
        }
        return p;
    }

    // Actualizar un perfil
    public boolean actualizarPerfil(Perfil p) {
        String sql = "UPDATE Perfiles SET nombrePerfil=?, descripcion=? WHERE idPerfil=?";
        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombrePerfil());
            ps.setString(2, p.getDescripcion());
            ps.setInt(3, p.getIdPerfil());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("❌ Error al actualizar perfil: " + e.getMessage());
            return false;
        }
    }

    // Eliminar un perfil
    public boolean eliminarPerfil(int id) {
        String sql = "DELETE FROM Perfiles WHERE idPerfil=?";
        try (Connection con = cn.crearConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("❌ Error al eliminar perfil: " + e.getMessage());
            return false;
        }
    }
}
