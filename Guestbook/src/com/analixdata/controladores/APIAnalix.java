package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.http.*;

import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;

public class APIAnalix extends HttpServlet {
	
	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		resp.setContentType("text/html");
	    String url = null;
	    

	    PrintWriter out = resp.getWriter();
	
	   
	      try {
	        String id = req.getParameter("idempresa");
	        String u = req.getParameter("usuario");
	        String pass = req.getParameter("pass");
	        
	  
	        
	        String encabezado =req.getHeader("Authorization");
	        
	        
	      //  ATRIBUTO: "+atributo+" ENCABEZADO "+encabezado
	        
	       /* final String authorization = httpRequest.getHeader("Authorization");
	        if (authorization != null && authorization.startsWith("Basic")) {
	            // Authorization: Basic base64credentials
	            String base64Credentials = authorization.substring("Basic".length()).trim();
	            String credentials = new String(Base64.getDecoder().decode(base64Credentials),
	                    Charset.forName("UTF-8"));
	            // credentials = username:password
	            final String[] values = credentials.split(":",2);
	*/
	   
		         //   out.println( "IDEMPRESA: "+id+" USUARIO:"+u+" PASS: "+pass+" ENCABEZADO "+encabezado);
		       
	        out.println( "RESPUESTA");
	      
	    } catch (Error e) {
	      e.printStackTrace();
	      out.println("ERROR");
	    
		} finally {
	  	  
	    }
	    //resp.sendRedirect("/empresa.jsp");

	  }

}
