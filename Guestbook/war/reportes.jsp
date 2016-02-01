<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>


<html>
<head>
	  	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
	  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
	    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
	  <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	  
	  <script>
		  $(function() {
		    $( "#fechaDesde" ).datepicker();
		    $( "#fechaHasta" ).datepicker();
		  });
	  </script>
	  
	  <SCRIPT type=text/javascript>
	
	
	$(function() {
	    $('#rEmpresa').on('change', function(event) {
	    	document.getElementById("btnContinuarReportes").click();
	    });
	});
	
		
		
	</SCRIPT> 
	  
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
	
	
	String url = null;
	if (SystemProperty.environment.value() ==
	    SystemProperty.Environment.Value.Production) {
	  // Load the class that provides the new "jdbc:google:mysql://" prefix.
	  Class.forName("com.mysql.jdbc.GoogleDriver");
	  url = "jdbc:google:mysql://pasarelasms-1190:analixdata/pasarelasms?user=root&password=1234";
	} else {
	  // Local MySQL instance to use during development.
	  Class.forName("com.mysql.jdbc.Driver");
	  url = "jdbc:mysql://localhost:3306/pasarelasms?user=geo";
	}

	Connection conn = DriverManager.getConnection(url);
	ResultSet rs = conn.createStatement().executeQuery(
	    "SELECT * FROM empresa WHERE estado=1");
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
			<h4 class="msgbienvenida">Bienvenido usuario <%= userName %></h4>
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
									<li ><a href="servicioEmpresa.jsp">Servcios a empresas</a></li>
									<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
								<%}
								
								if(tipo == 2){ 
									%>
										<li><a href="empresas.jsp">Empresa</a></li>
										<li ><a href="servicios.jsp">Servicios</a></li>
										<li><a href="usuarios.jsp">Usuarios</a></li>
										<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
									<%}
								
								if(tipo == 3){ 
									%>
										<li><a href="empresas.jsp">Empresa</a></li>
										<li ><a href="servicios.jsp">Servicios</a></li>
										<li><a href="usuarios.jsp">Usuario</a></li>
								
									<%}
								
							}
						%>
						
						
						<li><a href="mensajeria.jsp">Mensajería</a></li>
						<li><a href="mensajeria.jsp">Reportes</a></li>
						<li><a href="/cerrarSesion">Cerrar Sesión</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Reportes</h1>
				
				<form action="/reporteTransacciones">
					<table>
						<tr>
							<td>
								Desde: <input type="text" id="fechaDesde">
							</td>
							<td>
								Hasta: <input type="text" id="fechaHasta">
							</td>
							
						</tr>
						<tr>
							<td>
								Empresa: 
								<select name=reporteEmpresa id="rEmpresa" >
									<option>Seleccione una empresa....</option>	
									
									<% 
									while (rs.next())
									{
										String empresa = rs.getString("nombre");
										%>
										<option value=<%= empresa %>><%= empresa %></option>	
										<%
									}
									%>
									</select>
									<input type="submit" value="Continuar" name="btnContinuarReportes" id="btnContinuarReportes"/>
							</td>
							<td>
								<%
						
					
								if(!(session.getAttribute("listaUsuarios") == null)){
									
								List<Usuario> lista= (List<Usuario>)session.getAttribute("listaUsuarios");
						
								%>
								
								Usuario: <select name=reporteUsuario id="rUsuario" >
								<% 
								for( Usuario usuario:lista) 
								{
								%>
									<option value=<%= usuario.getId() %>><%= usuario.getNombres() %></option>
								<%
									}
								%>
								
								</select>
								<% 	
						}
					%>	
							</td>
							<td>
								Servicio: <select name=reporteServicio id="rServicio" >
							</td>
						</tr>
						<tr>
							<td>
								<input type="submit" value="Consultar" name="btnConsultar"/>
							</td>
						</tr>
					</table>
				</form>
	
			<table>
				<tr>
					<td>ID</td>
					<td>Fecha</td>
					<td>Hora</td>
					<td>Código de retorno</td>
					<td>Descripcion</td>
					<td>Celular</td>
					<td>Mensaje</td>
					<td>Servicio</td>
					<td>Usuario</td>
					<td>Empresa</td>
				</tr>
			</table>
			
			</div>	
	
		</div>
	</div>

  </body>
</html>
