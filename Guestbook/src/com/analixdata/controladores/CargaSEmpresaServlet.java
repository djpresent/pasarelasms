package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;

public class CargaSEmpresaServlet extends HttpServlet {
	
	@Override
	  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    String url = null;
	    
	    resp.setContentType("text/html;charset=UTF-8");
		HttpSession session = req.getSession();
        session = req.getSession();
        Usuario u = (Usuario)session.getAttribute("usuario"); 
        if (u!=null)
        {
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
	        String servicio = req.getParameter("servicioCarga");
	        String empresa = req.getParameter("empresaCarga");
	        String cupo = req.getParameter("cupoCarga");

	        
	        String idEmpresa=null;
	        
	        ResultSet rs = conn.createStatement().executeQuery("SELECT idempresa FROM empresa where nombre ='"+empresa+"';");
        	
        	if(rs.next()){
        		
        		 idEmpresa=Integer.toString(rs.getInt("idempresa"));
        		 
        	}
        	 
	        
	        if (idServicio == "" || idServicio == null ) {
	        	session.setAttribute("updateServEmp", 2);
	        	
	        } else {
	        	
	        	ResultSet rs3 = conn.createStatement().executeQuery("SELECT limite,disponible FROM servicio_empresa where idservicio ="+idServicio+";");
	        	
	        	System.out.println("idServicio "+idServicio);
	        	
	        	
	        	int limiteact=0;
	        	
	        	int disponible=0;
	        	
	        	if(rs3.first()){
	        		
	        		 limiteact=rs3.getInt("limite");
	        		 disponible=rs3.getInt("disponible");
	        		 
	        	}
	        	
	        
	        		
	        		disponible=Integer.parseInt(cupo)+disponible;
	        		limiteact=Integer.parseInt(cupo)+limiteact;
	        	

	        	
	        	String statement = "UPDATE servicio_empresa SET limite=? , disponible=? where idservicio=? and idempresa=?";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		      
		          stmt.setInt(1, limiteact);
		          stmt.setInt(2, disponible);
		          stmt.setString(3, idServicio);
		          stmt.setString(4, idEmpresa);
		          int success = 2;
		          
		         
		          System.out.println("Consulta "+stmt.toString());
		          
		          
		          success = stmt.executeUpdate();
		          if (success == 1) {
		        	  session.setAttribute("updateServEmp", 1);
		          } else if (success == 0) {
		        	  session.setAttribute("updateServEmp", 2);
		          }
	          
	        }
	      } finally {
	        conn.close();
	      }
	    } catch (SQLException e) {
	    	session.setAttribute("updateServEmp", 2);
	    }
	    resp.sendRedirect("/servicioEmpresa.jsp");
        }
        else
	    {
	    	
	    	session.invalidate();
	    	RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
            PrintWriter out= resp.getWriter();
            out.println("<div class=\"alert alert-warning\" style=\"text-align: center;\"><strong>Lo sentimos! </strong>Su sesión ha caducado. Por favor, vuelva a ingresar</div>	");
            try 
            {
				rd.include(req, resp);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    }
	    
	  }

}
