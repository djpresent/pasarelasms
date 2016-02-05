package com.analixdata.controladores;

import java.io.*;
import java.sql.*;

import javax.servlet.http.*;

import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;

public class APIAnalix extends HttpServlet {
	
	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		resp.setContentType("text/html;charset=UTF-8");
	    String url = null;
	    

	    PrintWriter out = resp.getWriter();
	    try {
	   
	      try {
	        String id = req.getParameter("idempresa");
	        String u = req.getParameter("usuario");
	        String pass = req.getParameter("pass");
	        
	        //String atributo =req.getAttribute("Authorization").toString();
	        
	       // String encabezado =req.getHeader("Authorization");
	        
	        
	      //  ATRIBUTO: "+atributo+" ENCABEZADO "+encabezado
	
	   
		            out.println( "IDEMPRESA: "+id+" USUARIO:"+u+" PASS: "+pass);
		       
	    
	      } finally {
	    	  
	      }
	    } catch (Error e) {
	      e.printStackTrace();
	      out.println("ERROR");
	    }
	    //resp.sendRedirect("/empresa.jsp");

	  }

}
