package com.analixdata.controladores;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;







public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		
		//String mensaje =req.getParameter("txtmensaje");
		
		//String str= "ANALIXDATA:JDL@nd13c";
		
		//String encoded = DatatypeConverter.printBase64Binary(str.getBytes());
	
		try {
			HttpResponse<String> response =
			        Unirest.post("https://api.infobip.com/sms/1/text/single")
			        .header("authorization", "Basic QU5BTElYREFUQTpKRExAbmQxM2M==")
			        .header("content-type", "application/json")
			        .header("accept", "application/json")
			        .body("{\"from\":\"Queti\",\"to\":[\"593985149552\"],\"text\":\"Para bailar la bamba\"}")
			        .asString();
		} catch (UnirestException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		//PrintWriter out = resp.getWriter();
		//out.println("<html><head></head><body>Failure! Please try again! " +
          ///      "Redirecting in 3 seconds..."+resp+"</body></html>");
		
			

	/*	protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
		{ 
		    // pre-flight request processing
		 //   resp.setHeader("Access-Control-Allow-Origin", "*");
		   /// resp.setHeader("Access-Control-Allow-Methods", SUPPORTED_METHODS);
		    ///resp.setHeader("Access-Control-Allow-Headers", SUPPORTED_HEADERS);
		}
*/
		
			
			
			
	//	String str= "Aladdin:open sesame";
		
		//String encoded = DatatypeConverter.printBase64Binary(str.getBytes());
		
		//String decoded = new String(DatatypeConverter.parseBase64Binary(encoded));
       
		
		
		//System.out.println(encoded);
		 //System.out.println("decoded value is \t" + decoded);
		
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
