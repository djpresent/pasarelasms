<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.analixdata.modelos.Usuario" %>


<html>
<head>
  	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Analixdata Servicios en Línea</title>
  </head>

  <body>

  <%

	
  	HttpSession sessionlog = request.getSession();
  	Usuario u = (Usuario)sessionlog.getAttribute("usuario");
  	
  	if (u==null)
  	{
  		
  		sessionlog.setAttribute("error", "error");
  		response.sendRedirect("/login.jsp");
  	}
	
  	
	String userName = null;
	String sessionID = null;
	Cookie[] cookies = request.getCookies();
	if(cookies !=null)
	{
		for(Cookie cookie : cookies)
		{
		    if(cookie.getName().equals("usuario")) userName = cookie.getValue();
		    if(cookie.getName().equals("JSESSIONID")) sessionID = cookie.getValue();
		
		}
	}
  	%>
  	
  	<nav class="navbar" >
  	<div class="container-fluid">
		<div class="navbar-header">
			<a href="index.jsp"><img class="logo" src="imagenes/logo-analix-data.png"/></a>
		</div>  
		
		<div class="navbar-nav navbar-right">
			<a href="/cerrarSesion"><button type="button" class="btn btn-lg btn-default cerrarsesion">Cerrar sesión <span class="glyphicon glyphicon-log-out"></span></button></a>
		</div>
		<div class="navbar-nav navbar-right ">
			<h4 class="msgbienvenida">Bienvenido usuario <%= userName %><img class="icousuario" src="imagenes/icousuario.png"/></h4>
			 
		</div>
		
	</div>	
  	</nav>
  	<div class="container-fluid">
	  	<div class="row">
			  	<div class="col-sm-3 col-md-2 sidebar"> 
				    <ul class="nav nav-sidebar">
						<%  
						if(u != null){
							
							int tipo=u.getTipo().getId();
							
							if(tipo == 1){ 
							%>
								<li><a href="empresas.jsp">Empresas</a></li>
								<li ><a href="servicios.jsp">Servicios</a></li>
								<li><a href="usuarios.jsp">Usuarios</a></li>
								<li ><a href="servicioEmpresa.jsp">Servicios a empresas</a></li>
								<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
									
									<li><a href="mensajeria.jsp">Mensajería</a></li>
									<li><a href="reportes.jsp">Reportes</a></li>
									
								<%}
							
							
							if(tipo == 2){ 
								%>
									<li><a href="empresa.jsp">Empresa</a></li>
									<li ><a href="serviciosContratados.jsp">Servicios</a></li>
									<li><a href="usuarios.jsp">Usuarios</a></li>
									<li><a href="servicioUEmpresa.jsp">Servicios a Usuarios</a></li>
									<%if( u.tieneServicio(1)){
										%>
									<li><a href="mensajeria.jsp">Mensajería</a></li>
									<li><a href="reportesEmpresas.jsp">Reportes</a></li>
									
									<%}
								}
							
							if(tipo == 3){ 
								%>
									<li><a href="empresa.jsp">Empresa</a></li>
									<li ><a href="serviciosContratados.jsp">Servicios</a></li>
									<li><a href="usuario.jsp">Usuario</a></li>
							
								<%
								
								if( u.tieneServicio(1)){
									%>
									
									<li><a href="mensajeria.jsp">Mensajería</a></li>
									<li><a href="reportesUsuarios.jsp">Reportes</a></li>
									
									<%}
							}
							
							
						
						
						%>
						
						
						
						<li><a href="/cerrarSesion">Cerrar Sesión</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Analixdata</h1>
			</div>	
	
		</div>
	</div>
	

  	<%} %>
  
  </body>
</html>
