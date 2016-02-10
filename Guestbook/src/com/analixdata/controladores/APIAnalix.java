package com.analixdata.controladores;

import java.io.*;
import java.nio.charset.Charset;
import java.sql.*;

import javax.servlet.http.*;

import org.apache.commons.codec.binary.Base64;


import com.google.appengine.api.utils.SystemProperty;

public class APIAnalix extends HttpServlet {
	
	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		resp.setContentType("text/html");

	        String u;
	        String pass;
	        String numero;
	        String mensaje;
      
	        
	      String authorization = req.getHeader("Authorization");
	        if (authorization != null && authorization.startsWith("Basic")) {
	            // Authorization: Basic base64credentials
	            String base64Credentials = authorization.substring("Basic".length()).trim();
	            String credentials = new String(Base64.decodeBase64(base64Credentials),
	                    Charset.forName("UTF-8"));
	            // credentials = username:password
	            String[] values = credentials.split(":",2);
	            u=values[0];
	            pass=values[2];
	            
	            numero=req.getParameter("numero");
	            mensaje=req.getParameter("mensaje");

	       		PrintWriter out = resp.getWriter();
	       		if(numero!=null && mensaje!=null){
	       			out.println("CORRECTO");
		        }else{
		        	out.println("PARAMETROS INCORRECTOS");
		        }
		   
		        out.close();
	      
	        }

	}
	}
