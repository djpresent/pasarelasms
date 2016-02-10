package com.analixdata.controladores;

import java.io.*;
import java.net.URL;
import java.net.HttpURLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.StringTokenizer;

import javax.servlet.http.*;

import org.apache.commons.codec.binary.Base64;

import com.analixdata.modelos.DAO;
import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;

public class APIAnalix extends HttpServlet {
	
	@Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		resp.setContentType("text/html");

	        String u=null;
	        String pass=null;
	        String numero=null;
	        String mensaje=null;
      

       		PrintWriter out = resp.getWriter();
	        
	      String authorization = req.getHeader("Authorization");
	        if (authorization != null && authorization.startsWith("Basic")) {
	            // Authorization: Basic base64credentials
	            String base64Credentials = authorization.substring("Basic".length()).trim();
	            String credentials = new String(Base64.decodeBase64(base64Credentials),
	                    Charset.forName("UTF-8"));
	            // credentials = username:password
	            int i=0;
	            
	            StringTokenizer st = new StringTokenizer(credentials);
	            while (st.hasMoreTokens()) {
	            	if(i==0){
	            		u=st.nextToken();
	            		i++;
	            	}
	            	if(i==1){
	            		pass=st.nextToken();
	            	}
	            }
	            
	            
	            
	            
	            if(u != null && pass !=null){
	            	DAO dao = new DAO();
	            	Usuario val = dao.existe( new Usuario(u,pass));
	        		
	            	if(val !=null){
	            
	            
	            
	            numero=req.getParameter("numero");
	            mensaje=req.getParameter("mensaje");
	            
	            

	            
	            if(numero!=null && mensaje!=null){
	            	
	        		String url = null;
	        	    try {
	        	      if (SystemProperty.environment.value() ==
	        	          SystemProperty.Environment.Value.Production) {

	        	        Class.forName("com.mysql.jdbc.GoogleDriver");
	        	        url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	        	      } else {

	        	        Class.forName("com.mysql.jdbc.Driver");
	        	        url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";

	        	      }
	        	    } catch (Exception e) {
	        	      e.printStackTrace();
	        	      return;
	        	    }

	        	    try {
	    				Connection conn = DriverManager.getConnection(url);
	    				
	    				String charset = "UTF-8";
	    		        String decmensaje = URLDecoder.decode(mensaje, charset);
	    				
	    		        String fecha= new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()).toString();
	    		        String hora=new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()).toString();
	    				
	    				String statement = "INSERT INTO transaccion (fecha,hora,retorno,plataforma,celular,mensaje,idservicio,idusuario,idempresa) VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? )";
	    		          PreparedStatement stmt = conn.prepareStatement(statement);
	    		          stmt.setString(1, fecha);
	    		          stmt.setString(2,  hora);
	    		          stmt.setString(3, "EN PROCESO");
	    		          stmt.setString(4, "API");
	    		          stmt.setString(5, numero);
	    		          stmt.setString(6, decmensaje);
	    		          stmt.setInt(7, 1);
	    		          stmt.setInt(8, val.getId());
	    		          stmt.setInt(9, val.getEmpresa().getIdEmpresa());
	    		          
	    		          int success = 2;
	    		          System.out.println(stmt);
	    		          success = stmt.executeUpdate();
	    		          
	    		          if(success==1){
	    		        	  
	    		        	  String urlEnvio = "http://envia-movil.com/Api/Envios?mensaje="+mensaje+"&numero="+numero;
	    		        		
	    		        		URL obj = new URL(urlEnvio);
	    		        		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
	    		        		con.setReadTimeout(60 * 1000);
	    		                con.setConnectTimeout(60 * 1000);

	    		        		con.setRequestMethod("GET");

	    		        		con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0");
	    		        		con.setRequestProperty ("Authorization", "Basic REM1NjIzMTVCM0NCOUVGOjA2MzZFM0FGMTQ=");
	    		        		int responseCode = con.getResponseCode();
	    		        		System.out.println("\nSending 'GET' request to URL : " + urlEnvio);
	    		        		System.out.println("Response Code : " + responseCode);
	    		        		
	    		        		if(responseCode==200){

		    		        		BufferedReader in = new BufferedReader(
		    		        		        new InputStreamReader(con.getInputStream()));
		    		        		String inputLine;
		    		        		StringBuffer response = new StringBuffer();
	
		    		        		while ((inputLine = in.readLine()) != null)
		    		        		{
		    		        			response.append(inputLine);
		    		        		}
		    		        		in.close();
		    		        		
		    		        		try{
		    		        		
		    		        		statement = "UPDATE transaccion SET retorno="+response.toString()+", WHERE fecha="+fecha+" and hora="+hora+" and idusuario="+val.getId()+"and celular='"+numero+"'";
		    		 		       
		    		        		success = 2;
		  	    		            System.out.println(stmt);
		  	    		            success = stmt.executeUpdate();
		  	    		            
		  	    		            	out.println(response);
		  	    		            
		    		        		}catch (Error e){
		    		        			
		    		        		}finally{
		    		        			out.println(response);
		    		        		}
		  	    		            
		  	    		            
		    		        		
	    		        		}else{
	    		        			out.println("ERROR DE ENVIO");
	    		        			
	    		        		}
	    		          }
	    		         
	    		          
	    		          
	    				
		    			} catch (SQLException e) {
		    				out.println("ERROR DE CONEXION");
	
		    				e.printStackTrace();
		    			}
	    	
	        		
		            }else{
			        	out.println("PARAMETROS INCORRECTOS");
			        }
		          
	            	}else{
	            		out.println("NO AUTORIZADO");
	            	}
	            }else{
	            	out.println("NO AUTORIZADO");
	            	
	            }
	      
	        }else{
	        	out.println("NO AUTORIZADO");
	        	
	        }
	        out.close();
	        

	
	}
}

