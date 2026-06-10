/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Mr_Fagua
 */
public class Conexion {
 public static String usuario="root";
 public static String clave="12345";
 public static String servidor="127.0.0.1:3306";
 public static String BD="acadflow";
   
 public Connection 
crearConexion()
 {
 Connection con=null;

 try
 {
 Class.forName("com.mysql.cj.jdbc.Driver");
 String URL="jdbc:mysql://"+servidor+"/"+BD;
 con=DriverManager.getConnection(URL, usuario,clave);
 }
 catch(java.lang.ClassNotFoundException ex)
 {
 System.out.println("classnotfound");
 }
 catch(SQLException e)
 {
 System.out.println("error de enlace canal");}

 return con;
 }
}
