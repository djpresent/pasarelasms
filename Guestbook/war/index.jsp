<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.analixdata.modelos.Usuario" %>


<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Hello App Engine</title>
  </head>

  
  <body>
  
  <%

	HttpSession sessionlog = request.getSession();
  	Usuario u = (Usuario)sessionlog.getAttribute("usuario");
  	
  	if (u==null)
  	{
  		response.sendRedirect("/login.jsp");
  	}
  	else
  	{
  	%>
  		<h1>Administrador web!</h1> 
    <ul>
		<li type="circle"><a href="empresas.jsp">Empresas.</a></li>
		<li type="circle"><a href="servicios.jsp">Servicios.</a></li>
		<li type="circle"><a href="usuarios.jsp">Usuarios.</a></li>
		<li type="circle">Mensajería.</li>
		<li type="circle">Reportes.</li>
		<li type="circle"><a href="/cerrarSesion">Cerrar Sesión.</a></li>

	</ul>
  	<% 	
  	}
	%>
  
  
    

  </body>
</html>
