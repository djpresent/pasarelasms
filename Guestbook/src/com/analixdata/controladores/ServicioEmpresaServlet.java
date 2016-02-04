package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.http.*;

import com.google.appengine.api.utils.SystemProperty;

public class ServicioEmpresaServlet extends HttpServlet {
	
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
	        	
	        
	        	
	        	String statement = "INSERT INTO servicio_empresa (idservicio,idempresa,limite,costotransaccion,estado,disponible) VALUES( ? , ? , ? , ? , ? ,?)";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, idServicio);
		          stmt.setString(2, idEmpresa);
		          stmt.setString(3, limite);
		          stmt.setString(4, costo);
		          stmt.setString(5, estado);
		          stmt.setString(6, limite);
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
	        	
	        	rs = conn.createStatement().executeQuery("SELECT limite,disponible FROM servicio_empresa where idservicio ="+idServicio+";");
	        	
	        	int limiteact=0;
	        	
	        	int disponible=0;
	        	
	        	if(rs.next()){
	        		
	        		 limiteact=rs.getInt("limite");
	        		 disponible=rs.getInt("dispponible");
	        		 
	        	}
	        	
	        	if(Integer.parseInt(limite)>limiteact){
	        		
	        		disponible=(Integer.parseInt(limite)-limiteact)+disponible;
	        	}
	        	
	        	if(Integer.parseInt(limite)<limiteact){
	        		if(Integer.parseInt(limite)>disponible){
	        			disponible=(limiteact-Integer.parseInt(limite))+disponible;
	        			
	        		}else{

	        			disponible=Integer.parseInt(limite);
	        		}
	        		
	        	}

	        	
	        	String statement = "UPDATE servicio_empresa SET idservicio=?, idempresa=?, limite=? ,costotransaccion=? ,estado=?, disponible=? ";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, idServicio);
		          stmt.setString(2, idEmpresa);
		          stmt.setString(3, limite);
		          stmt.setString(4, costo);
		          stmt.setString(5, estado);
		          stmt.setInt(6, disponible);
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
