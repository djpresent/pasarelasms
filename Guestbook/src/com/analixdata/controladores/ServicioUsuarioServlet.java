package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.http.*;

import com.google.appengine.api.utils.SystemProperty;

public class ServicioUsuarioServlet extends HttpServlet {
	
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
	    	String idServicio = req.getParameter("idServicio");
	        String servicio = req.getParameter("servicio");
	        String empresa = req.getParameter("empresa");
	        String limite = req.getParameter("limite");
	        String costo = req.getParameter("costo");
	        String estado = req.getParameter("estado");
	        
	        String idEmpresa=null;
	        
	        ResultSet rs = conn.createStatement().executeQuery("SELECT idempresa FROM empresa where nombre ='"+empresa+"';");
        	
        	if(rs.next()){
        		
        		 idEmpresa=Integer.toString(rs.getInt("idempresa"));
        		 
        	}
        	 
	        
	        if (idServicio == "" || idServicio == null ) {
	        	
	            rs = conn.createStatement().executeQuery("SELECT idservicio FROM servicio where descripcion ='"+servicio+"';");
	        	
	        	if(rs.next()){
	        		
	        		 idServicio=Integer.toString(rs.getInt("idservicio"));
	        		 
	        	}
	        	
	        
	        	
	        	String statement = "INSERT INTO servicio_empresa (idservicio,idempresa,limite,costotransaccion,estado) VALUES( ? , ? , ? , ? , ? )";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, idServicio);
		          stmt.setString(2, idEmpresa);
		          stmt.setString(3, limite);
		          stmt.setString(4, costo);
		          stmt.setString(5, estado);
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

	        	
	        	String statement = "UPDATE servicio_empresa SET idservicio=?, idempresa=?, limite=? ,costotransaccion=? ,estado=? ";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, idServicio);
		          stmt.setString(2, idEmpresa);
		          stmt.setString(3, limite);
		          stmt.setString(4, costo);
		          stmt.setString(5, estado);
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
	          
	        }
	      } finally {
	        conn.close();
	      }
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	    resp.sendRedirect("/servicioEmpresa.jsp");
	  }

}
