package com.analixdata.controladores;
import java.io.IOException;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import javax.xml.bind.DatatypeConverter;

import com.analixdata.modelos.DAO;
import com.analixdata.modelos.Usuario;

public class ValidarServlet extends HttpServlet {

	protected void processRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException,IOException
	{
		resp.setContentType("text/html;charset=UTF-8");
		DAO dao = new DAO();
		
		String email,pass;
		
		email=req.getParameter("txtEmail");
		pass = req.getParameter("txtPassword");
		
		Usuario u = new Usuario(email,pass);
		Usuario u2 = dao.existe(u);
		
		if (u2==null)
		{
			HttpSession session = req.getSession();
			session.setAttribute("usuario", u2);
			req.getRequestDispatcher("error.jsp").forward(req, resp);
		}
		else
		{
			HttpSession session = req.getSession();
			session.setAttribute("usuario", u2);
			
			
			String str= "Aladdin:open sesame";
			
			String encoded = DatatypeConverter.printBase64Binary(str.getBytes());
			
			
			session.setAttribute("autorizacion", "Basic "+encoded );
			//req.getRequestDispatcher("index.jsp").forward(req, resp);
			resp.sendRedirect("index.jsp");
		}	
		
		
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
