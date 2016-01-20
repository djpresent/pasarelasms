package com.analixdata.modelos;

import com.google.appengine.api.utils.SystemProperty;
import java.sql.*;

public class DAO {
	
	public Usuario existe(Usuario u)
	{
		
		String url = null;
	    try {
	      if (SystemProperty.environment.value() ==
	          SystemProperty.Environment.Value.Production) {
	        // Load the class that provides the new "jdbc:google:mysql://" prefix.
	        Class.forName("com.mysql.jdbc.GoogleDriver");
	        url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	      } else {
	        // Local MySQL instance to use during development.
	        Class.forName("com.mysql.jdbc.Driver");
	        url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";
	        
	        Connection conn = DriverManager.getConnection(url);
		    ResultSet rs = conn.createStatement().executeQuery(
		        "SELECT * FROM USUARIO WHERE email='"+u.getEmail()+"' and password='"+u.getPassword()+"'");
		    
		    if (!rs.isBeforeFirst()) 
		    {    
		    	 return null; 
		    }
		    else
		    {
		    	ResultSet rs1 = conn.createStatement().executeQuery("SELECT * FROM empresa WHERE idempresa='"+rs.getInt("idempresa")+"'");
		    	ResultSet rs2 = conn.createStatement().executeQuery("SELECT * FROM tipo WHERE idtipo='"+rs.getInt("idtipo")+"'");
		    	
		    	Tipo tipo=new Tipo();
		    	Empresa empresa = new Empresa();
		    	
		    	while (rs1.next())
		    	{
		    		tipo.setId(rs1.getInt("idtipo"));
		    		tipo.setDescripcion(rs1.getString("descripcion"));
		    	}
		    	
		    	while (rs2.next())
		    	{
		    		empresa.setIdEmpresa(rs2.getInt("idempresa"));
		    		empresa.setNombre(rs2.getString("nombre"));
		    		empresa.setDireccion(rs2.getString("direccion"));
		    		empresa.setTelefono(rs2.getString("telefono"));
		    		empresa.setContacto(rs2.getString("contacto"));
		    		empresa.setEstado(rs2.getInt("estado"));
		    	}
		    	
		    	
		    	return new Usuario (rs.getInt("idusuario"),rs.getString("cedula"),rs.getString("nombres"),rs.getString("apellidos"),rs.getString("cargo"),rs.getString("email"),rs.getString("telefono"),rs.getString("password"),rs.getInt("estado"),empresa,tipo);
		    }
		    
	      }
	    } catch (Exception e) 
	    {
	      e.printStackTrace();
	    }
		return u;

	}
}
