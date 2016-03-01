package com.analixdata.controladores;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.utils.SystemProperty;




import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class OlvidePasswordServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		String url = null;
		String email = req.getParameter("txtEmail");
		try 
		{
	  	      if (SystemProperty.environment.value() ==
	  	          SystemProperty.Environment.Value.Production) {

	  	        Class.forName("com.mysql.jdbc.GoogleDriver");
	  	        url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	  	      } else {

	  	        Class.forName("com.mysql.jdbc.Driver");
	  	        url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";

	  	      }
	  	      
	  	      Connection conn = DriverManager.getConnection(url);
	  	      String sentencia = "SELECT * FROM usuario where email='"+email+"';";
	  	      
	  	      ResultSet rs=conn.createStatement().executeQuery(sentencia);
	  	      
	  	      if (rs.first())
	  	      {
	  	    	int id = rs.getInt("idusuario");
	  	    	Properties props = new Properties();
	  	        Session session = Session.getDefaultInstance(props, null);

	  	        String msgBody = "Mensaje de prueba ";

	  	        try 
	  	        {
	  	            Message msg = new MimeMessage(session);
	  	            msg.setFrom(new InternetAddress("pasarelasms-1190@appspot.gserviceaccount.com", "AnalixData Admin"));
	  	            msg.addRecipient(Message.RecipientType.TO,
	  	                             new InternetAddress(email, "Mr. User"));
	  	            msg.setSubject("Your Example.com account has been activated");
	  	            msg.setText(msgBody);
	  	            Transport.send(msg);
	  	            
	  	          RequestDispatcher rd = getServletContext().getRequestDispatcher("/mailRestablecer.jsp");
	  	    	  PrintWriter out= resp.getWriter();
	  	    	  out.println("<div class=\"alert alert-success\" style=\"text-align: center;\"><strong>Ok ! </strong>Revise su bandeja de entrada para obtener información de restablecimiento de su contraseña.</div>	");


	  	        } catch (AddressException e) 
	  	        {
	  	            
	  	        	RequestDispatcher rd = getServletContext().getRequestDispatcher("/mailRestablecer.jsp");
	  	        	PrintWriter out= resp.getWriter();
	  	        	out.println("<div class=\"alert alert-danger\" style=\"text-align: center;\"><strong>Error ! </strong>Direccion no encontrada.</div>	");

		  	    	try 
		  	    	  {
						rd.include(req, resp);
		  	    	  } catch (ServletException t) 
		  	    	  {
						t.printStackTrace();
		  	    	  }

		  	    	  
	  	        } catch (MessagingException e) {
		  	        	RequestDispatcher rd = getServletContext().getRequestDispatcher("/mailRestablecer.jsp");
		  	        	PrintWriter out= resp.getWriter();
		  	        	out.println("<div class=\"alert alert-danger\" style=\"text-align: center;\"><strong>Error ! </strong>Desconocido."+e+"</div>	");
	
			  	    	try 
			  	    	  {
							rd.include(req, resp);
			  	    	  } catch (ServletException t) 
			  	    	  {
							t.printStackTrace();
			  	    	  }
	  	        }
	  	      }
	  	      else
	  	      {
	  	    	  RequestDispatcher rd = getServletContext().getRequestDispatcher("/mailRestablecer.jsp");
	  	    	  PrintWriter out= resp.getWriter();
	  	    	  out.println("<div class=\"alert alert-danger\" style=\"text-align: center;\"><strong>Error! </strong>Verifique su email.</div>	");
	  	    	  try 
	  	    	  {
					rd.include(req, resp);
	  	    	  } catch (ServletException t) 
	  	    	  {
					t.printStackTrace();
	  	    	  }
	  	      }
	  	     
	  	      
	  	      
		} 
		catch (Exception e) 
		{
	  	    	RequestDispatcher rd = getServletContext().getRequestDispatcher("/mailRestablecer.jsp");
	            PrintWriter out= resp.getWriter();
	            out.println("<div class=\"alert alert-danger\" style=\"text-align: center;\"><strong>Error! </strong>Hubo un problema con el sistema. Por favor, contacte con su administrador.</div>	");
	            try 
	            {
					rd.include(req, resp);
				} catch (ServletException t) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		processRequest(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		processRequest(req, resp);
	}

	
}
