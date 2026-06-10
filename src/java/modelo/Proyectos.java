/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.util.Date;

/**
 *
 * @author Heriberto
 */
public class Proyectos {

    private int idProyecto;
    private String nombreProyecto;
    private String descripcion;
    private Date fechaInicio;
    private Date fechaFinal;
    private int creadoPor;

    public int getIdProyecto() {
        return idProyecto;
    }

    public void setIdProyecto(int idProyecto) {
        this.idProyecto = idProyecto;
    }

    public String getNombreProyecto() {
        return nombreProyecto;
    }

    public void setNombreProyecto(String nombreProyecto) {
        this.nombreProyecto = nombreProyecto;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public int getCreadoPor() {
        return creadoPor;
    }

    public void setCreadoPor(int creadoPor) {
        this.creadoPor = creadoPor;
    }

    // MÉTODOS DE RESUMENpublic int getTotalTareas() {
    public int getTotalTareas() {
        TareaDAO dao = new TareaDAO();
        return dao.contarTareasPorProyecto(this.idProyecto);
    }

    public int getTareasCompletadas() {
        TareaDAO dao = new TareaDAO();
        return dao.contarTareasCompletadasPorProyecto(this.idProyecto);
    }

}
