package com.analixdata.controladores;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.servlet.http.HttpSession;
import org.apache.commons.io.IOUtils;




public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		String jsonResponse = null;
        String postData = "{\"from\":\"Queti\",\"to\":[ \"593992831273\"],\"text\":\"Mensaje de prueba ANALIXDATA\"}";
        
        URL myURL = new URL("https://api.infobip.com/sms/1/text/single");
        HttpURLConnection myURLConnection = (HttpURLConnection)myURL.openConnection();
       // String userCredentials = "username:password";
        //String basicAuth = "Basic " + new String(new Base64().encode(userCredentials.getBytes()));
        myURLConnection.setReadTimeout(60 * 1000);
        myURLConnection.setConnectTimeout(60 * 1000);
        myURLConnection.setRequestProperty ("Authorization", "Basic QU5BTElYREFUQTpKRExAbmQxM2M==");
        myURLConnection.setRequestMethod("POST");
        //myURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        //myURLConnection.setRequestProperty("Content-Length", "" + Integer.toString(postData.getBytes().length));
        myURLConnection.setRequestProperty("content-type", "application/json");
        myURLConnection.setRequestProperty("accept", "application/json");

        myURLConnection.setUseCaches(false);
        myURLConnection.setDoInput(true);
        myURLConnection.setDoOutput(true);
        
        OutputStreamWriter writer = new OutputStreamWriter(myURLConnection.getOutputStream());
            writer.write(postData);
            writer.close();
        
        
        int responseCode = myURLConnection.getResponseCode();
        
        if (responseCode == 200) {
                InputStream inputStr = myURLConnection.getInputStream();
                String encoding = myURLConnection.getContentEncoding() == null ? "UTF-8"
                        : myURLConnection.getContentEncoding();
                jsonResponse = IOUtils.toString(inputStr, encoding);
                /************** For getting response from HTTP URL end ***************/

        }
        
        HttpSession session=req.getSession(true);
        session.setAttribute("codigo", jsonResponse); 
		resp.sendRedirect("mensajeria.jsp");
		
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
