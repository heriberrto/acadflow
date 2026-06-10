package modelo;

public class Actividad {
    private int id;
    private String nombreActividad;
    private String enlace;
    private String icono;

    // ===== Getters y Setters =====
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getNombreActividad() {
        return nombreActividad;
    }
    public void setNombreActividad(String nombreActividad) {
        this.nombreActividad = nombreActividad;
    }

    public String getEnlace() {
        return enlace;
    }
    public void setEnlace(String enlace) {
        this.enlace = enlace;
    }

    public String getIcono() {
        return icono;
    }
    public void setIcono(String icono) {
        this.icono = icono;
    }

    // ===== Para depuración o logging =====
    @Override
    public String toString() {
        return "Actividad{" +
                "id=" + id +
                ", nombreActividad='" + nombreActividad + '\'' +
                ", enlace='" + enlace + '\'' +
                ", icono='" + icono + '\'' +
                '}';
    }
}
