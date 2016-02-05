<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>

<html>
<HEAD>

	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
	

	
	$(function() {
	    $('#userEmpresa').on('change', function(event) {
	    	document.getElementById("btnServicios").click();
	    });
	});
	
	function validar(){
		
	
		if(document.getElementById("userEmpresa").value == "nousuario" ){
			
			alert("No ha seleccionado un usuario.");
		}
		
	}
	
		
		
	</SCRIPT> 
   </HEAD>

  <body>

<%

//allow access only if session exists

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
	    "SELECT * FROM usuario WHERE estado=1 and idempresa="+u.getEmpresa().getIdEmpresa()+";");
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
						
					
						<li><a href="/cerrarSesion">Cerrar Sesión.</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Asignación de Servicios a Usuarios</h1>
				<form  action="/asignarServicioUEmpresa" onsubmit="validar()">

				<div>Seleccione un usuario:
					<select name=userEmpresa id="userEmpresa" > 
					<option value="nousuario">Seleccionar...</option>
					<% 
					while (rs.next()) {
					String usuario = rs.getString("idusuario");
					
					System.out.println(session.getAttribute("usuario"));
					
					if(!(session.getAttribute("idusuario") == null)){
							
							if(usuario.equals(session.getAttribute("idusuario"))){%>
								<option value=<%= usuario %> selected ><%= usuario %></option>
							<%}else{%>
							<option value=<%= usuario %>><%= usuario %></option>
					<%	
							}
						}else{%>
						<option value=<%= usuario %>><%= usuario %></option>
					<%}}
					%>
					</select><input type="submit" class="oculto" value="Continuar" name="btnServicios" id="btnServicios"/>
					</div>
				
					<%
						
					
			
				
						if(!(session.getAttribute("serviciosU") == null) && !(session.getAttribute("idusuario") == null)){
							
						List<Servicio> listaS= (List<Servicio>)session.getAttribute("serviciosU");
						
					%>
					   
							<div>Seleccione un servicio:
														<% 
								for( Servicio ser:listaS) {
									
									if(ser.getAsignado()==1){
								%>
								
									
									<input type="checkbox" name="<%=ser.getDescripcion() %>" checked> <%=ser.getDescripcion() %><br>
						
									
								<%
								
									}else{
										
										%>
										<input type="checkbox" name="<%=ser.getDescripcion() %>"> <%=ser.getDescripcion() %><br>
										
										<%
									}
									}
								%>
				  
							
					<% 	
						}
					%>	
					</div>
				    
				    
				
				<div><input type="submit" value="Guardar" name="btnGuardar"/><input type="submit" value="Cancelar" name="btnCancelar"/> </div>
					<%
				
						
						
						if(!(session.getAttribute("confirmacion") == null)){
							if(session.getAttribute("confirmacion").equals("1")){
							%>
								<div><h3 id="msgConfirmacion">Operación realizada exitosamente.</h3></div>
							<%
							}
							}
					conn.close();
					%>
				
				
				  </form>
			</div>	
	
		</div>
	</div>
	
<%} %>



  </body>
</html>