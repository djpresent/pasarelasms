package com.analixdata.modelos;

import com.google.appengine.api.utils.SystemProperty;
import java.sql.*;

public class DAO {
	
	public Usuario existe(Usuario u)
	{
		
		
	    try {
	    	String url = "";
	    	if (SystemProperty.environment.value() ==
	    	    SystemProperty.Environment.Value.Production) {
	    	  // Load the class that provides the new "jdbc:google:mysql://" prefix.
	    	  Class.forName("com.mysql.jdbc.GoogleDriver");
	    	  url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	    	} else {
	    	  // Local MySQL instance to use during development.
	    	  Class.forName("com.mysql.jdbc.Driver");
	    	  url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";
	    	}
	        
	        Connection conn = DriverManager.getConnection(url);
		    ResultSet rs = conn.createStatement().executeQuery(
		        "SELECT * FROM usuario WHERE email='"+u.getEmail()+"' and password='"+u.getPassword()+"';");
		    
		    if (!rs.isBeforeFirst()) 
		    {    
		    	 return null; 
		    }
		    else
		    {
		    	while(rs.next())
		    	{
		    	ResultSet rs1 = conn.createStatement().executeQuery("SELECT * FROM empresa WHERE idempresa='"+rs.getInt("idempresa")+"';");
		    	ResultSet rs2 = conn.createStatement().executeQuery("SELECT * FROM tipo WHERE idtipo='"+rs.getInt("idtipo")+"';");
		    	
		    	Tipo tipo=new Tipo();
		    	Empresa empresa = new Empresa();
		    	
		    	while (rs2.next())
		    	{
		    		tipo.setId(rs2.getInt("idtipo"));
		    		tipo.setDescripcion(rs2.getString("descripcion"));
		    	}
		    	
		    	while (rs1.next())
		    	{
		    		empresa.setIdEmpresa(rs1.getInt("idempresa"));
		    		empresa.setNombre(rs1.getString("nombre"));
		    		empresa.setDireccion(rs1.getString("direccion"));
		    		empresa.setTelefono(rs1.getString("telefono"));
		    		empresa.setContacto(rs1.getString("contacto"));
		    		empresa.setEstado(rs1.getInt("estado"));
		    	}
		    	
		    	
		    	return new Usuario (rs.getInt("idusuario"),rs.getString("cedula"),rs.getString("nombres"),rs.getString("apellidos"),rs.getString("cargo"),rs.getString("email"),rs.getString("telefono"),rs.getString("password"),rs.getInt("estado"),empresa,tipo);
		    
		    	}
		    }
	      
	    } catch (Exception e) 
	    {
	      e.printStackTrace();
	    }
		return null;

	}
}
