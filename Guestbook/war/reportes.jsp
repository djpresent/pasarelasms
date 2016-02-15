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
	  <script src="js/jquery.table2excel.js"></script>
	  
	  <script type="text/javascript" src="js/tableExport.js"></script>
	  <script type="text/javascript" src="js/jquery.base64.js"></script>
	  <script type="text/javascript" src="js/sprintf.js"></script>
	  <script type="text/javascript" src="js/jspdf.js"></script>
	  <script type="text/javascript" src="js/base64.js"></script>
	  
	  <script>
		  $(function() {
		    $( "#fechaDesde" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
		    
		    $( "#fechaHasta" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
		  });

	  </script>
	  
	  <SCRIPT type=text/javascript>
	
	
		$(function() {
		    $('#rEmpresa').on('change', function(event) {
		    	document.getElementById("btnContinuarReportes").click();
		    });
		});
	
		$(function() {
		    $('#rUsuario').on('change', function(event) {
		    	document.getElementById("btnContinuarUusuario").click();
		    });
		});
		
		$("#tablaResultados").table2excel({
		    exclude: ".excludeThisClass",
		    name: "Worksheet Name",
		    filename: "SomeFile" //do not include extension
		});
		
		function CreateExcelSheet ()
		{
				
				$(".table2excel").table2excel({
					exclude: ".noExl",
					name: "Excel Document Name",
					filename: "reportes",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
			
		}
		
		function CreatePDF ()
		{
			$('#table2excel').tableExport({type:'pdf',escape:'false'});
				
			
		}

	</SCRIPT> 
	
	
	  
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
			<a href="/cerrarSesion" class="cerrarsesion"><img class="imglogout" src="imagenes/imglogout.png"/></button></a>
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
								<li><a href="empresas.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresas</h5></a></li>
								<li ><a href="servicios.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
								<li><a href="usuarios.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuarios</h5></a></li>
								<li ><a href="servicioEmpresa.jsp"><h5>Servicios a empresas</h5></a></li>
								<li><a href="servicioUsuarios.jsp"><h5>Servicios a Usuarios</h5></a></li>
									
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportes.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
								<%}
							
							
							if(tipo == 2){ 
								%>
									<li><a href="empresa.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresa</h5></a></li>
									<li ><a href="serviciosContratados.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
									<li><a href="usuarios.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuarios</h5></a></li>
									<li><a href="servicioUEmpresa.jsp">Servicios a Usuarios</a></li>
									<%if( u.tieneServicio(1)){
										%>
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportesEmpresas.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
									<%}
								}
							
							if(tipo == 3){ 
								%>
									<li><a href="empresa.jsp"><h5><img class="icomenu" src="imagenes/icoempresa.png"/>Empresa</h5></a></li>
									<li ><a href="serviciosContratados.jsp"><h5><img class="icomenu" src="imagenes/icoservicios.png"/>Servicios</h5></a></li>
									<li><a href="usuario.jsp"><h5><img class="icomenu" src="imagenes/icousuarios.png"/>Usuario</h5></a></li>
							
								<%
								
								if( u.tieneServicio(1)){
									%>
									
									<li><a href="mensajeria.jsp"><h5><img class="icomenu" src="imagenes/icomensajeria.png"/>Mensajería</h5></a></li>
									<li><a href="reportesUsuarios.jsp"><h5><img class="icomenu" src="imagenes/icoreportes.png"/>Reportes</h5></a></li>
									
									<%}
							}
							
							
						
						
						%>
						
						
						
						<li><a href="/cerrarSesion"><img class="icomenu" src="imagenes/icocerrar.png"/>Cerrar Sesión</a></li>
				
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Reportes</h1>
				
				<form action="/reporteTransacciones">
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
	
        			<div class="row">
        				<div class="col-xs-3">
        					<div class="form-group">
        						<label for="rEmpresa">Empresa</label>
        						<select class="form-control" name=reporteEmpresa id="rEmpresa" >
									<option value="noempresa" >Seleccione una empresa....</option>	
									
									<% 
										while (rs.next()) {
										String empresa = rs.getString("nombre");
										
										if(!(session.getAttribute("empresa") == null)){
												
												if(empresa.equals(session.getAttribute("empresa"))){%>
													<option value=<%= empresa %> selected ><%= empresa %></option>
												<%}else{%>
												<option value=<%= empresa %>><%= empresa %></option>
										<%	
												}
											}else{%>
											<option value=<%= empresa %>><%= empresa %></option>
										<%}}
										%>
								</select>
								<input type="submit" class="oculto" value="Continuar" name="btnContinuarReportes" id="btnContinuarReportes"/>
        					</div>
        				</div>
        				
        				<div class="col-xs-3">
        					<div class="form-group">
        						<label for="rUsuario">Usuarios</label>
        							<%

									if(!(session.getAttribute("listaUsuarios") == null))
									{
										
									List<Usuario> lista= (List<Usuario>)session.getAttribute("listaUsuarios");
							
									%>
									
									<select class="form-control" name=reporteUsuario id="rUsuario" >
									<option value="nousuario" >Seleccione un usuario....</option>	
									<% 
									
									/*if (session.getAttribute("usu").equals("nousuario"))
									{
										System.out.println(session.getAttribute("entroooo"));
										session.setAttribute("usu", null);
									}*/
									for( Usuario usuario:lista) 
									{
										//System.out.println("Dentro del for "+session.getAttribute("usu"));
										//if(!(session.getAttribute("usu") == null) )
										//{
									%>
											
									<option value=<%= usuario.getId() %>><%= usuario.getNombres() %></option>
										
										
									<%
									}
									%>
									
									</select>
									<input type="submit" class="oculto" value="ContinuarUs" name="btnContinuarUsuarios" id="btnContinuarUsuarios"/>
									<% 	
									}
									%>	
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
						<table class="table table-bordered table2excel" id="table2excel">
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
						 <input type="button" onclick="CreateExcelSheet()" value="Exportar a Excel"></input>
						 
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
	<footer class="footer">
      <div class="container" style="margin-left:25px;margin-right:-25px;">
      	 <div class="footizquierda">Analixdata, 2015 | Copyright © 2016. Todos los derechos reservados.</div>
       	  <div class="footderecha">Teléfono: 593 07 3701919   Email: lalvarez@analixdata.com<img class="icoheader" style="margin-left:10px;" src="imagenes/icogoogle.png"/> <img class="icoheader" src="imagenes/icotwitter.png"/> <a href="https://www.facebook.com/AnalixData-Cia-Ltda-1053799024633059/?fref=ts" target="_blank"><img class="icoheader" src="imagenes/icofacebook.png"/></a></div>
    
      </div>
    </footer>
<%} %>
  </body>
</html>
