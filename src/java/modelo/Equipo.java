package modelo;

public class Equipo {
    private int id_equipo;
    private String nombre_equipo;
    private int id_docente;
    private int id_estudiante;
    private String nombre_docente;

    public int getIdEquipo() { return id_equipo; }
    public void setIdEquipo(int id_equipo) { this.id_equipo = id_equipo; }

    public String getNombreEquipo() { return nombre_equipo; }
    public void setNombreEquipo(String nombre_equipo) { this.nombre_equipo = nombre_equipo; }

    public int getIdDocente() { return id_docente; }
    public void setIdDocente(int id_docente) { this.id_docente = id_docente; }

    public int getIdEstudiante() { return id_estudiante; }
    public void setIdEstudiante(int id_estudiante) { this.id_estudiante = id_estudiante; }

    public String getNombreDocente() { return nombre_docente; }
    public void setNombreDocente(String nombre_docente) { this.nombre_docente = nombre_docente; }
}
