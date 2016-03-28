package com.analixdata.controladores;

import java.io.BufferedReader;
import java.io.IOException;


import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.analixdata.modelos.Usuario;
import com.google.appengine.api.appidentity.AppIdentityService;
import com.google.appengine.api.appidentity.AppIdentityServiceFactory;




@SuppressWarnings("serial")
public class SubirServlet extends HttpServlet {
	
	

	/*private static final int BUFFER_SIZE = 1024 * 1024;
	
	 private final GcsService gcsService = GcsServiceFactory.createGcsService(new RetryParams.Builder()
	    .initialRetryDelayMillis(10)
	    .retryMaxAttempts(10)
	    .totalRetryPeriodMillis(15000)
	    .build());
	   
	 
	
	private void copy(InputStream input, OutputStream output) throws IOException {
	    try {
	      byte[] buffer = new byte[BUFFER_SIZE];
	      int bytesRead = input.read(buffer);
	      while (bytesRead != -1) {
	        output.write(buffer, 0, bytesRead);
	        bytesRead = input.read(buffer);
	      }
	    } finally {
	      input.close();
	      output.close();
	    }
	  }
	*/

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		HttpSession session=req.getSession(true); //Se obtiene la session actual
		session = req.getSession();
		Usuario u = (Usuario)session.getAttribute("usuario"); 
		/*if (u!=null)
        {

		//conexion a la 
		/*
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
  	    	session.setAttribute("codigo", 1);
			resp.sendRedirect("subir.jsp");
  	    }
		
		session.setAttribute("codigo", 1);
		resp.sendRedirect("subir.jsp");
		
		//FileItemFactory factory = new DiskFileItemFactory();
		//ServletFileUpload upload = new ServletFileUpload(factory);
		
		String sctype = null, sfieldname, sname = null;
		ServletFileUpload upload;
        FileItemIterator iterator;
        FileItemStream item;
        InputStream stream = null;

		try {
		
			upload = new ServletFileUpload();
            iterator = upload.getItemIterator(req);
            while (iterator.hasNext()) {
                item = iterator.next();
                stream = item.openStream();

                if (!item.isFormField()){

                	System.out.println("Es imagen");
                   sfieldname = item.getFieldName();
                    sname = item.getName();

                    sctype = item.getContentType();

                    GcsFilename gcsfileName = new GcsFilename("analixdata", sname);

                    GcsFileOptions options = new GcsFileOptions.Builder()
                    .acl("public-read").mimeType(sctype).build();

                    GcsOutputChannel outputChannel =gcsService.createOrReplace(gcsfileName, options);

                    copy(stream, Channels.newOutputStream(outputChannel));

                    session.setAttribute("codigo", 1);
                    
                    System.out.println("LLega al final");
                    
                    resp.sendRedirect("subir.jsp");
                    
                    
                    
                  //LLEGA HASTA AQUI Y LUEGO VA AL CATCH, EL ARCHIVO NO SE ALMACENA
              
                }
            }
		
		} catch (Exception e) {
				
			System.out.println(e);
			session.setAttribute("codigo", 6);
			resp.sendRedirect("subir.jsp");
		
		}catch(Error e){
			
			//SIEMPRE ENTRA POR AQUI
			System.out.println(e);
			session.setAttribute("codigo", 7);
			resp.sendRedirect("subir.jsp");
		}
		*
		
        }
		else
	    {
	    	
	    	session.invalidate();
	    	RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");
            PrintWriter out= resp.getWriter();
            out.println("<div class=\"alert alert-warning\" style=\"text-align: center;\"><strong>Lo sentimos! </strong>Su sesión a caducado. Por favor, vuelva a ingresar</div>	");
            try 
            {
				rd.include(req, resp);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	
	    }
	
		*/
		
		/*String cadena="{\"web\": {\"client_id\": \"335544489774-pvf6v6ibovjavi03b2vhderpli7um0b5.apps.googleusercontent.com\","+
		"\"project_id\": \"pasarelasms-1190\",\"auth_uri\": \"https://accounts.google.com/o/oauth2/auth",
		"token_uri": "https://accounts.google.com/o/oauth2/token",
		"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
		"client_secret": "cAAq6ld4GgTuogtwjWZBBKP4",
		"redirect_uris": ["https://servicios.analixdata.com"]
	}
}";
		
		URL obj = new URL("https://accounts.google.com/o/oauth2/auth");
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setReadTimeout(60 * 5000);
        con.setConnectTimeout(60 * 5000);
        
        //con.setRequestProperty ("Authorization", "Basic REM1NjIzMTVCM0NCOUVGOjA2MzZFM0FGMTQ=");
		con.setRequestMethod("POST");
		con.setRequestProperty("content-type", "application/json");
        con.setRequestProperty("accept", "application/json");

        con.setUseCaches(false);
        con.setDoInput(true);
        con.setDoOutput(true);
        
        OutputStreamWriter writer = new OutputStreamWriter(con.getOutputStream());
            writer.write(cadena);
            writer.close();
		//con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0");
		
		int responseCode = con.getResponseCode();
		
		
		
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
    		System.out.println(response);
    		in.close();
			
		}
		
		con.disconnect();
		*/
		
		String xmlString = "";
		  xmlString += "<AccessControlList><Entries>";
		  xmlString += "  <Entry>";
		  xmlString += "    <Scope type=\"UserByEmail\">foo@example.com</Scope>";
		  xmlString += "    <Permission>READ</Permission>";
		  xmlString += "  </Entry>";
		  xmlString += "</Entries></AccessControlList>";

		  ArrayList scopes = new ArrayList();
		  scopes.add("https://www.googleapis.com/auth/devstorage.full_control");

		  AppIdentityService.GetAccessTokenResult accessToken =
		      AppIdentityServiceFactory.getAppIdentityService().getAccessToken(scopes);
		  
		 System.out.println("Token" +accessToken.getAccessToken()); 
	
			
		 session.setAttribute("token", accessToken.getAccessToken());
		 
		   resp.sendRedirect("subir.jsp");

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
