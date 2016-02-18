package com.analixdata.controladores;

import java.io.IOException;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.analixdata.modelos.Transaccion;
import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;




public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		/*
		 * Este servlet realiza el envio de un listado de mensajes obtenido a partir de un archivo de texto, csv o excel.
		 * */
		
		HttpSession session=req.getSession(true); //Se obtiene la session actual
		session = req.getSession();
		Usuario u = (Usuario)session.getAttribute("usuario"); 
		String disp =  (String) session.getAttribute("disponibles");
		int env = Integer.parseInt(disp);
		List <Transaccion> mensajes = new ArrayList<Transaccion>();
		String url = null;
		
		//conexion a la 
		
		try {
  	      if (SystemProperty.environment.value() ==
  	          SystemProperty.Environment.Value.Production) {

  	        Class.forName("com.mysql.jdbc.GoogleDriver");
  	        url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
  	      } else {

  	        Class.forName("com.mysql.jdbc.Driver");
  	        url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";

  	      }
  	    } catch (Exception e) 
		{
  	    	session.setAttribute("codigo", "ERRORBASE");
			resp.sendRedirect("mensajeria.jsp");
  	    }

		
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);

		try {
		
			FileItemIterator iterator = upload.getItemIterator(req);
			String mensaje = null;
			FileItemStream uploadedFile = null;
			while (iterator.hasNext()) 
			{
	            FileItemStream uploaded = iterator.next();
	            
	            if (!uploaded.isFormField()) 
	            {

					   uploadedFile =  uploaded;   

					   if (uploadedFile.getContentType().equalsIgnoreCase("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
					   {					   
						   XSSFWorkbook workBook = new XSSFWorkbook(uploadedFile.openStream());
						   XSSFSheet sheet = workBook.getSheetAt(0); 
						   
						   System.out.println("El numero de filas es: "+sheet.getPhysicalNumberOfRows());
						   for (int i=0;i<sheet.getPhysicalNumberOfRows();i++)
						   {
							   XSSFRow row = sheet.getRow(i);
							   String mtemp = mensaje;
							   if (!row.getCell(0).toString().equalsIgnoreCase(""))
							   {
								   System.out.println("El valor del numero es: "+row.getCell(0).toString());
								   if (row.getCell(1)!=null)  
									   mtemp = mtemp.replace("[VARIABLE1]", row.getCell(1).toString());
								   
								   if (row.getCell(2)!=null)  
									   mtemp = mtemp.replace("[VARIABLE2]", row.getCell(2).toString());
								   
								   if (row.getCell(3)!=null)  
									   mtemp = mtemp.replace("[VARIABLE3]", row.getCell(3).toString());
								   
								   if (row.getCell(4)!=null)  
									   mtemp = mtemp.replace("[VARIABLE4]", row.getCell(4).toString());
	
								   Transaccion mens = new Transaccion (row.getCell(0).toString(),mtemp);
								   mensajes.add(mens);
							   }
							   else
							   {
								  break; 
							   }
						   	}
						   
					   }
					   else
					   {

						   BufferedReader br = null;
						   String line;
							try {

								br = new BufferedReader(new InputStreamReader(uploadedFile.openStream()));
								while ((line = br.readLine()) != null) 
								{

									String mtemp = mensaje;
									String numero=null;
								    StringTokenizer st = new StringTokenizer(line,";");
								    int i=0;
								    
								    if (st.countTokens()>0)
								    {
									    while(st.hasMoreTokens()) 
									    {
									    	if (i==0){
									    		 numero = st.nextToken();
									    		 
									    		
									    	}
									    	if (i==1)
									    	{
									    		String variable1 = st.nextToken();
									    		if (!variable1.equals(""))
									    			mtemp = mtemp.replace("[VARIABLE1]", variable1);
									    	}
									    	if (i==2)
									    	{
									    		String variable2 = st.nextToken();
									    		if (!variable2.equals(""))
									    			mtemp = mtemp.replace("[VARIABLE2]", variable2);
									    	}
									    	if (i==3)
									    	{
									    		String variable3 = st.nextToken();
									    		if (!variable3.equals(""))
									    			mtemp = mtemp.replace("[VARIABLE3]", variable3);
									    	}
									    	if (i==4)
									    	{
									    		String variable4 = st.nextToken();
									    		System.out.println("Esta es la variable 4"+variable4);
									    		if (!variable4.equals(""))
									    			mtemp = mtemp.replace("[VARIABLE4]", variable4);
	
									    	}
									    	i++;
									    }

									   Transaccion mens = new Transaccion (numero,mtemp);
									   mensajes.add(mens);
								    }
									
									
								}

							} catch (IOException e) {
								session.setAttribute("codigo", "ERRORTEXTO");
								resp.sendRedirect("mensajeria.jsp");
							} finally {
								if (br != null) {
									try {
										br.close();
									} catch (IOException e) {
										e.printStackTrace();
									}
								}
							}
						 
					   }
				   }
				   else
				   {
					   if (uploaded.getFieldName().equals("mensaje"))
					   {
						  
						   mensaje = IOUtils.toString(uploaded.openStream(), "utf-8"); 

					   }

				   }
	            
	            
	        }

			if (Integer.parseInt(disp)>=mensajes.size())
			{	
				
				Connection conn = DriverManager.getConnection(url);
				int enviados=0;
				PrintWriter out = resp.getWriter();
				String charset = "UTF-8";
				for (int i = 0; i<mensajes.size();i++)
				{
					
					String decmensaje = URLEncoder.encode(mensajes.get(i).getMensaje(), charset);
					String urlEnvio ="http://envia-movil.com/Api/Envios?mensaje="+decmensaje+"&numero="+mensajes.get(i).getCelular() ;
					URL obj = new URL(urlEnvio);
	        		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
	        		con.setReadTimeout(60 * 5000);
	                con.setConnectTimeout(60 * 5000);
	
	        		con.setRequestMethod("GET");
	
	        		con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0");
	        		con.setRequestProperty ("Authorization", "Basic REM1NjIzMTVCM0NCOUVGOjA2MzZFM0FGMTQ=");
	        		int responseCode = con.getResponseCode();
	        		//System.out.println("\nSending 'GET' request to URL : " + urlEnvio);
	        		//System.out.println("Response Code : " + responseCode);
	        		
	        		
	        		
	        		if(responseCode==200)
	        		{
	
		        		BufferedReader in = new BufferedReader(
		        		        new InputStreamReader(con.getInputStream()));
		        		String inputLine;
		        		StringBuffer response = new StringBuffer();
	
		        		while ((inputLine = in.readLine()) != null)
		        		{
		        			response.append(inputLine);
		        		}
		        		in.close();
		        		
		        		try
		        		{
		        			
		        			Calendar cal = Calendar.getInstance(); // creates calendar
		    	    		
		    		        cal.add(Calendar.HOUR_OF_DAY, -5); // adds one hour

		    		         		        
		    		        String fecha= new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime()).toString();
		    		        String hora=new SimpleDateFormat("HH:mm:ss").format(cal.getTime()).toString();
		        			
		    		       
		    		        String respuesta=response.toString();
		        			
		        			if(response.toString().equals("\"Mensaje enviado\"")){
		        				respuesta="MENSAJE ENVIADO";
		        				
		        				enviados++;

		        			}
		        			
		        			if(response.toString().equals("\"Error al enviar mensaje\"")){
		        				respuesta="MENSAJE NO ENVIADO";
		        			
		        			}
		    		        
		        			String statement = "INSERT INTO transaccion (fecha,hora,retorno,plataforma,celular,mensaje,idservicio,idusuario,idempresa) VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? )";
		    		          PreparedStatement stmt = conn.prepareStatement(statement);
		    		          stmt.setString(1, fecha);
		    		          stmt.setString(2,  hora);
		    		          stmt.setString(3, respuesta);
		    		          stmt.setString(4, "FRONTEND");
		    		          stmt.setString(5, mensajes.get(i).getCelular());
		    		          stmt.setString(6, URLDecoder.decode(decmensaje,"UTF-8"));
		    		          stmt.setInt(7, 1);
		    		          stmt.setInt(8, u.getId() );
		    		          stmt.setInt(9, u.getEmpresa().getIdEmpresa());
		    		          
		    		          stmt.executeUpdate();
	  		            
		        		}catch (Error e){
		        			session.setAttribute("codigo", "ERRORGRABARBASE");
		    				resp.sendRedirect("mensajeria.jsp");
		        		}
			
	        		}
	        		
	        		con.disconnect();

				}
				
				String stmt1 = "UPDATE servicio_empresa SET disponible="+(env-enviados)+" WHERE idempresa="+u.getEmpresa().getIdEmpresa();
				PreparedStatement stmt = conn.prepareStatement(stmt1);
				stmt.executeUpdate();
				
				conn.close();
				
				
				session.setAttribute("codigo", "ENVIADOS");
				resp.sendRedirect("mensajeria.jsp");
				
			}
			else
			{
				//System.out.println(mensajes.size());
				session.setAttribute("codigo", "NOENVIADOS");
				resp.sendRedirect("mensajeria.jsp");
			}
			
			
			
		
		} catch (FileUploadException e) {
			
			session.setAttribute("codigo", "ERRORSUBIRARCHIVO");
			resp.sendRedirect("mensajeria.jsp");
			
			///e.printStackTrace();
		} catch (Exception e) {

			session.setAttribute("codigo", "ERRORGENERAL");
			resp.sendRedirect("mensajeria.jsp");
		
		}
	
		
	//	resp.sendRedirect("mensajeria.jsp");

	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		processRequest(req, resp);
	

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		processRequest(req, resp);
		
	}

}
