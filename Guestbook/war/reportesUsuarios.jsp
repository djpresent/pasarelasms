<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>
<%@ page import="com.analixdata.modelos.Transaccion" %>


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
		    $( "#fechaDesde" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
		    
		    $( "#fechaHasta" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
		  });
		  
		  
		  
	  </script>
    <title>Analixdata Servicios en Línea</title>
  </head>

  <body>

  <%

	
  	session = request.getSession();
	Usuario u = (Usuario)session.getAttribute("usuario");
		
	if (u==null)
	{
			
	session.setAttribute("error", "error");
	response.sendRedirect("/login.jsp");
	
	}
	String userName = null;
	String sessionID = null;
	Cookie[] cookies = request.getCookies();
	if(cookies !=null){
	for(Cookie cookie : cookies){
	if(cookie.getName().equals("usuario")) 
		userName = cookie.getValue();
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
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Reportes</h1>
				
				<form action="/reporteUsuariosTransacciones">
					
					<div class="row">
        				<div class="col-xs-3">
        					<div class="form-group">
							    <label for="fechaDesde">Desde</label>
								<%
									if (!(session.getAttribute("fDesde") == null))
									{
										String fd= session.getAttribute("fDesde").toString();
								%>
												
								<input type="text" class="form-control" placeholder="Fecha inicial de busqueda" id="fechaDesde" name ="fechaDesde"  value=<%=fd %> required="required" >
								<% 
									}
									else
									{
								%>
								<input type="text" class="form-control" placeholder="Fecha inicial de busqueda" id="fechaDesde" name ="fechaDesde" required="required" >
								<% 
			
									}
								%>
							</div>
        				</div>
        				
        				<div class="col-xs-3">
        					<div class="form-group">
	        				<label for="fechaHasta">Hasta</label>
							<%
								if (!(session.getAttribute("fHasta") == null))
								{
									String fa= session.getAttribute("fHasta").toString();
							%>
											
							<input type="text" class="form-control" placeholder="Fecha final de busqueda" id="fechaHasta" name ="fechaHasta"  value=<%=fa %> required="required"  >
							<% 
								}
								else
								{
							%>
							<input type="text" class="form-control" placeholder="Fecha final de busqueda" id="fechaHasta" name ="fechaHasta" required="required">
							<% 			
								}
							%>		
							</div>
        				</div>

        				<div class="col-xs-3 vert-offset-top-1-8">
        					<div class="form-group">
        						<label for="btnConsultar"></label> 
        						<input class="btn btn-default" type="submit" value="Consultar" name="btnConsultar"/>
        					</div>
        				</div>
        				
        			</div>
				</form>
				
				
			<div class="table-responsive">

				<%
					if(!(session.getAttribute("transacciones") == null))
					{
						List <Transaccion> transacciones = (List <Transaccion>)session.getAttribute("transacciones");
						if (transacciones.size()>0)
						{
				%>
						
						<h4>Los resultados son:</h4>
						<table class="table table-bordered">
						<tr>
							<td>ID</td>
							<td>Fecha</td>
							<td>Hora</td>
							<td>Código de retorno</td>
							<td>Descripcion</td>
							<td>Celular</td>
							<td>Mensaje</td>
							<td>Empresa</td>
							<td>Usuario</td>
							<td>Servicio</td>
						</tr>
					<% 
						for (int i =0;i< transacciones.size();i++)
						{
							%>
							<tr>
								<td><%= transacciones.get(i).getId() %></td>
								<td><%= transacciones.get(i).getFecha() %></td>
								<td><%= transacciones.get(i).getHora() %></td>
								<td> <%= transacciones.get(i).getCodRetorno() %></td>
								<td></td>
								<td><%= transacciones.get(i).getCelular() %></td>
								<td><%= transacciones.get(i).getMensaje() %></td>
								<td><%= transacciones.get(i).getNombreEmpresa() %></td>
								<td><%= transacciones.get(i).getNombreUsuario() %></td>
								<td><%= transacciones.get(i).getNombreServicio() %></td>
							</tr>
							<% 
						}
						%>
						</table>
						<%
						}
						else
						{
							%>
							<h4>No existen resultados para esta consulta. Por favor, verifique las fechas</h4>
							<% 
						}
					}
					else
					{
						%>
						<h4>No existen resultados para esta consulta. Por favor, verifique las fechas</h4>
						<% 
					}
				%>
				
			</div>
			</div>	
		</div>
	</div>
	<%} %>
  </body>
</html>
