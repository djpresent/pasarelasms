package com.analixdata.controladores;
import java.io.IOException;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.DatatypeConverter;

import org.apache.http.HttpResponse;

import com.analixdata.modelos.DAO;
import com.analixdata.modelos.Usuario;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;





public class EnvioMensajesServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		
		String mensaje =req.getParameter("txtmensaje");
		
	
			/*HttpResponse response=null;
			try {
				response = (HttpResponse) Unirest.post("https://api.infobip.com/sms/1/text/multi")
						  .header("authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
						  .header("content-type", "application/json")
						  .header("accept", "application/json")
						  .body(mensaje)
						  .asString();
			} catch (UnirestException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			System.out.println(response);
			*/
	

		
		String str= "Aladdin:open sesame";
		
		String encoded = DatatypeConverter.printBase64Binary(str.getBytes());
		
		String decoded = new String(DatatypeConverter.parseBase64Binary(encoded));
       
		
		
		System.out.println(encoded);
		 System.out.println("decoded value is \t" + decoded);
		
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		processRequest(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		processRequest(req, resp);
	}

}
