package com.analixdata.controladores;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;










import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.analixdata.modelos.Empresa;
import com.analixdata.modelos.Usuario;
import com.google.appengine.api.utils.SystemProperty;




public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);


		// req es la HttpServletRequest que recibimos del formulario.
		// Los items obtenidos serán cada uno de los campos del formulario,
		// tanto campos normales como ficheros subidos.
		List items;
		try {
			items = upload.parseRequest(req);
			// Se recorren todos los items, que son de tipo FileItem
			for (Object item : items) {
			   FileItem uploaded = (FileItem) item;

			   // Hay que comprobar si es un campo de formulario. Si no lo es, se guarda el fichero
			   // subido donde nos interese
			   if (!uploaded.isFormField()) {
			      // No es campo de formulario, guardamos el fichero en algún sitio
			      String line=null;
				   File fichero = new File("/tmp", uploaded.getName());
			     
			      FileReader fileReader =  new FileReader(fichero);
			      BufferedReader bufferedReader =  new BufferedReader(fileReader);

			            while((line = bufferedReader.readLine()) != null) {
			                System.out.println(line);
			            }   

			            // Always close files.
			            bufferedReader.close(); 
			      
			      System.out.println(fichero.getName());
			      //uploaded.write(fichero);
			   } else {
			      // es un campo de formulario, podemos obtener clave y valor
			      String key = uploaded.getFieldName();
			      String valor = uploaded.getString();
			      
			      System.out.println(key+" "+valor);
			   }
			}
			
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		
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
		//processRequest(req, resp);
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
