<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.analixdata.modelos.Usuario" %>


<html>
<head>
  	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Analixdata Servicios en Línea</title>
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
  	
  	<nav class="navbar navbar-inverse">
  	<div class="container-fluid">
		<div class="navbar-header">
			<img src="imagenes/logo.png"/>
		</div>  
	</div>	
  	</nav>
  	<div class="container-fluid">
	  	<div class="row">
			  	<div class="col-sm-3 col-md-2 sidebar"> 
				    <ul class="nav nav-sidebar">
						<li><a href="empresas.jsp">Empresas.</a></li>
						<li ><a href="servicios.jsp">Servicios.</a></li>
						<li><a href="usuarios.jsp">Usuarios.</a></li>
						<li><a href="mensajeria.jsp">Mensajería.</a></li>
						<li><a href="mensajeria.jsp">Reportes.</a></li>
						<li><a href="/cerrarSesion">Cerrar Sesión.</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Analixdata</h1>
			</div>	
	
		</div>
	</div>
	

  	<% 	
  	}
	%>
  
  </body>
</html>
