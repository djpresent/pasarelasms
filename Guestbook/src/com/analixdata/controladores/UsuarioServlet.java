package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.http.*;

import com.google.appengine.api.utils.SystemProperty;

public class UsuarioServlet extends HttpServlet {
	
	@Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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

	        // Alternatively, connect to a Google Cloud SQL instance using:
	        // jdbc:mysql://ip-address-of-google-cloud-sql-instance:3306/guestbook?user=root
	      }
	    } catch (Exception e) {
	      e.printStackTrace();
	      return;
	    }

	    PrintWriter out = resp.getWriter();
	    try {
	      Connection conn = DriverManager.getConnection(url);
	      try {
	    	String id = req.getParameter("identificador");
	        String cedula = req.getParameter("cedula");
	        String nombres = req.getParameter("nombres");
	        String apellidos = req.getParameter("apellidos");
	        String cargo = req.getParameter("cargo");
	        String telefono = req.getParameter("telefono");
	        String email = req.getParameter("email");
	        String password = req.getParameter("password");
	        String estado = req.getParameter("estado");
	        String tipo = req.getParameter("tipo");
	        String empresa = req.getParameter("empresa");
	        String idtipo=null;
	        
	  
	        
	        if (id == "" || id == null ) {
	        	
	        	ResultSet rs = conn.createStatement().executeQuery("SELECT idtipo FROM tipo where descripcion ='"+tipo+"'");
	        	
	        	if(rs.first()){
	        		
	        		 idtipo= rs.getString("idtipo");
	        	}
	        	
	        	System.out.println(idtipo);
	        	
	        	String statement = "INSERT INTO usuario (cedula,nombres,apellidos,cargo,telefono,email,password,estado,idtipo) VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? )";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, cedula);
		          stmt.setString(2, nombres);
		          stmt.setString(3, apellidos);
		          stmt.setString(4, cargo);
		          stmt.setString(5, telefono);
		          stmt.setString(6, email);
		          stmt.setString(7, password);
		          stmt.setString(8, estado);
		          stmt.setString(9, idtipo);
		          int success = 2;
		          success = stmt.executeUpdate();
		          if (success == 1) {
		            out.println(
		                "<html><head></head><body>Success! Redirecting in 3 seconds...</body></html>");
		          } else if (success == 0) {
		            out.println(
		                "<html><head></head><body>Failure! Please try again! " +
		                "Redirecting in 3 seconds...</body></html>");
		          }
	          
	        } else {
	        	
	        	String statement = "UPDATE usuario SET cedula=?, nombres=?, apellidos=? ,cargo=? ,telefono=? ,email=? ,password=?, estado=?, idtipo=? WHERE idusuario=? ";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, cedula);
		          stmt.setString(2, nombres);
		          stmt.setString(3, apellidos);
		          stmt.setString(4, cargo);
		          stmt.setString(5, telefono);
		          stmt.setString(6, email);
		          stmt.setString(7, password);
		          stmt.setString(8, estado);
		          stmt.setString(9, idtipo);
		          stmt.setString(10, id);
		          int success = 2;
		          
		          System.out.println(cedula+" "+nombres+" "+apellidos+" "+cargo+" "+telefono+" "+email+" "+password+" "+estado+" "+id );
		          System.out.println(statement);
		          
		          success = stmt.executeUpdate();
		          if (success == 1) {
		            out.println(
		                "<html><head></head><body>Success! Redirecting in 3 seconds...</body></html>");
		          } else if (success == 0) {
		            out.println(
		                "<html><head></head><body>Failure! Please try again! " +
		                "Redirecting in 3 seconds...</body></html>");
		          }
	          
	        }
	      } finally {
	        conn.close();
	      }
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	    resp.sendRedirect("/usuarios.jsp");
	  }

}
