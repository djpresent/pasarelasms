package com.analixdata.controladores;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;




















import java.io.PrintWriter;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;







import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.sl.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.analixdata.modelos.DAO;
import com.analixdata.modelos.Empresa;
import com.analixdata.modelos.Transaccion;
import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;




public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		HttpSession session=req.getSession(true);
		session = req.getSession();
		Usuario u = (Usuario)session.getAttribute("usuario");
		//String mensaje = req.getParameter("mensaje");
//		String disponibles = req.getParameter("disponibles");
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
	//	System.out.println(mensaje+" "+disponibles);
		
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);


		// req es la HttpServletRequest que recibimos del formulario.
		// Los items obtenidos serán cada uno de los campos del formulario,
		// tanto campos normales como ficheros subidos.
		List items;
		try {
			items = upload.parseRequest(req);
			// Se recorren todos los items, que son de tipo FileItem
			FileItem uploadedFile = null;
			String mensaje = null;
			List <Transaccion> mensajes = new ArrayList();
			for (Object item : items) 
			{
			   FileItem uploaded = (FileItem) item;

			   // Hay que comprobar si es un campo de formulario. Si no lo es, se guarda el fichero
			   // subido donde nos interese
			   if (!uploaded.isFormField()) {
				   
			      // No es campo de formulario, guardamos el fichero en algún sitio
				   uploadedFile = uploaded;   
			   }
			   else
			   {
				   if (uploaded.getFieldName().equals("mensaje"))
				   
				   mensaje = uploaded.getString();

			   }
			}
			
			if (uploadedFile.getContentType().equalsIgnoreCase("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
			   {					   
				   XSSFWorkbook workBook = new XSSFWorkbook(uploadedFile.getInputStream());
				   XSSFSheet sheet = workBook.getSheetAt(0); 
				   
				  // System.out.println(sheet.getRow(1).getPhysicalNumberOfCells());
				   for (int i=0;i<sheet.getPhysicalNumberOfRows();i++)
				   {
					   XSSFRow row = sheet.getRow(i);
					   String mtemp = mensaje;
					   if (row.getCell(1)!=null)  
						   mtemp = mtemp.replace("[VARIABLE1]", row.getCell(1).toString());
					   
					   if (row.getCell(2)!=null)  
						   mtemp = mtemp.replace("[VARIABLE2]", row.getCell(2).toString());
					   
					   if (row.getCell(3)!=null)  
						   mtemp = mtemp.replace("[VARIABLE3]", row.getCell(3).toString());
					   
					   if (row.getCell(4)!=null)  
						   mtemp = mtemp.replace("[VARIABLE4]", row.getCell(4).toString());

					   //System.out.println(row.getCell(0)+" "+row.getCell(1)+" "+row.getCell(2)+""+row.getCell(3));
					   System.out.println(mtemp);
					   Transaccion mens = new Transaccion (row.getCell(0).toString(),mtemp);
					   
					   mensajes.add(mens);
				   }

				   /*if (row.getCell(0).getCellType() == XSSFCell.CELL_TYPE_STRING) {
						System.out.println(row.getCell(0).getStringCellValue());
					}
					if (row.getCell(1).getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
						System.out.println(row.getCell(1).getDateCellValue());
					}*/

			   }
			   else
			   {
				   BufferedReader reader = new BufferedReader(new InputStreamReader(uploadedFile.getInputStream()));
					for (String line; (line = reader.readLine()) != null;) 
					{
						String mtemp = mensaje;
						String numero=null;
					    StringTokenizer st = new StringTokenizer(line,";");
					    int i=0;
					    System.out.println(st.countTokens());
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
					    
						   //System.out.println(row.getCell(0)+" "+row.getCell(1)+" "+row.getCell(2)+""+row.getCell(3));
						   System.out.println(numero+" sms: "+mtemp);
						   Transaccion mens = new Transaccion (numero,mtemp);
						   mensajes.add(mens);
					    
						//System.out.println(line);
					}
			   }
			
			for (int i =0; i<mensajes.size();i++)
			{
				PrintWriter out = resp.getWriter();
				String charset = "UTF-8";
				String decmensaje = URLEncoder.encode(mensajes.get(i).getMensaje(), charset);
				String urlEnvio ="http://envia-movil.com/Api/Envios?mensaje="+decmensaje+"&numero="+mensajes.get(i).getCelular() ;
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
	        			
	        		
	        			Connection conn = DriverManager.getConnection(url);
	    		        java.util.TimeZone zone = java.util.TimeZone.getTimeZone("America/Quito");
	    		        String fecha= new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance(zone).getTime()).toString();
	    		        String hora=new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance(zone).getTime()).toString();
	        			String statement = "INSERT INTO transaccion (fecha,hora,retorno,plataforma,celular,mensaje,idservicio,idusuario,idempresa) VALUES( ? , ? , ? , ? , ? , ? , ? , ? , ? )";
	    		          PreparedStatement stmt = conn.prepareStatement(statement);
	    		          stmt.setString(1, fecha);
	    		          stmt.setString(2,  hora);
	    		          stmt.setString(3, response.toString());
	    		          stmt.setString(4, "FRONTEND");
	    		          stmt.setString(5, mensajes.get(i).getCelular());
	    		          stmt.setString(6, decmensaje);
	    		          stmt.setInt(7, 1);
	    		          stmt.setInt(8, u.getId() );
	    		          stmt.setInt(9, u.getEmpresa().getIdEmpresa());
	    		          
	    		          int success = 2;
	    		          System.out.println(stmt);
	    		          success = stmt.executeUpdate();
  		            
	        		}catch (Error e){
	        			
	        		}finally{
	        			out.println(response);
	        		}
		
        		}else
        		{
        			out.println("ERROR DE ENVIO");
        			
        		}
			}
			
			
			
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		resp.sendRedirect("mensajeria.jsp");
		
		/*String jsonResponse = null;
        
        //String mensaje = req.getParameter("txtmensaje");
        //String numero = req.getParameter("txtmensaje");
		String mensaje = "Este es un mensaje de prueba";
        String numero = "593992831273";

        URL myURL = new URL("http://envia-movil.com/Api/Envios");
        HttpURLConnection myURLConnection = (HttpURLConnection)myURL.openConnection();
       // myURLConnection.setReadTimeout(60 * 1000);
        //myURLConnection.setConnectTimeout(60 * 1000);
        myURLConnection.setRequestProperty ("Authorization", "Basic REM1NjIzMTVCM0NCOUVGOjA2MzZFM0FGMTQ==");
        myURLConnection.setRequestMethod("GET");
        //myURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        //myURLConnection.setRequestProperty("Content-Length", "" + Integer.toString(postData.getBytes().length));
        myURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        //myURLConnection.setRequestProperty("accept", "application/json");

        myURLConnection.setUseCaches(false);
        myURLConnection.setDoInput(true);
        myURLConnection.setDoOutput(true);
        
        String charset = "UTF-8";
        String s = "mensaje=" + URLEncoder.encode(mensaje, charset);
        s += "&numero=" + URLEncoder.encode(numero, charset);
        
        
       OutputStreamWriter writer = new OutputStreamWriter(myURLConnection.getOutputStream());

            writer.write(s);
          //  writer.wr
        writer.close();
        
        
        int responseCode = myURLConnection.getResponseCode();
        
        if (responseCode == 200) {
                InputStream inputStr = myURLConnection.getInputStream();
                String encoding = myURLConnection.getContentEncoding() == null ? "UTF-8"
                        : myURLConnection.getContentEncoding();
                jsonResponse = IOUtils.toString(inputStr, encoding);
                /************** For getting response from HTTP URL end ***************/

        /*}
        
        HttpSession session=req.getSession(true);
        session.setAttribute("codigo", jsonResponse); 
        session.setAttribute("sms", mensaje);
		resp.sendRedirect("mensajeria.jsp");
		*/
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		processRequest(req, resp);
	/*	System.out.println("hOLAAA");
		
		
		String charset = "UTF-8";
		String numero="593992845597";
        String mensaje = URLEncoder.encode("Mensaje de prueba para Geovanny by ANALIXDATA", charset);
     
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

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null)
		{
			response.append(inputLine);
		}
		in.close();

        if (responseCode == 200) 
        {
        	HttpSession session=req.getSession(true);

    		Usuario u = (Usuario)session.getAttribute("usuario");
    		
    	
    		
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
				
				String statement = "INSERT INTO transaccion (fecha,hora,codigoretorno,celular,mensaje,idservicio,idusuario,idempresa) VALUES( ? , ? , ? , ? , ? , ? , ? , ? )";
		          PreparedStatement stmt = conn.prepareStatement(statement);
		          stmt.setString(1, new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()).toString());
		          stmt.setString(2, new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()).toString() );
		          stmt.setString(3, "1");
		          stmt.setString(4, numero);
		          stmt.setString(5, mensaje);
		          stmt.setInt(6, 1);
		          stmt.setInt(7, u.getId());
		          stmt.setInt(8, u.getEmpresa().getIdEmpresa());
		          
		          int success = 2;
		          System.out.println(stmt);
		          success = stmt.executeUpdate();
		         
		          
		          
				
			} catch (SQLException e) {

				e.printStackTrace();
			}
    	    
    	    session.setAttribute("codigo", inputLine); 
    		resp.sendRedirect("mensajeria.jsp");
    	    
        }*/

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		processRequest(req, resp);
		
	}

}
