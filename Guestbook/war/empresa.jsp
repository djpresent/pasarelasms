<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>

<html>
<HEAD>

 	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
  	
	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
		function validar(formObj){
		
			if (formObj.direccion.value == ""){
				alert("Datos imcompletos");
				return false;
				}else if (formObj.telefono.value == ""){
					alert("Datos imcompletos");
					return false;
					}else if (formObj.contacto.value == ""){
						alert("Datos imcompletos");
						return false;}else return true;
			}
		
		
		function habilitar(){
			
			document.getElementById("formEmpresa").style.display="block";
			document.getElementById("dirEmpresa").value=document.getElementById("valorDireccion").innerHTML;
			document.getElementById("telEmpresa").value=document.getElementById("valorTelefono").innerHTML;
			document.getElementById("conEmpresa").value=document.getElementById("valorContacto").innerHTML;

		}
		
		function deshabilitar(){
			
			document.getElementById("formEmpresa").style.display="none";
	

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
	if(cookies !=null)
	{
		for(Cookie cookie : cookies)
		{
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
    "SELECT * FROM empresa");
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
						
						
						<li><a href="/cerrarSesion">Cerrar Sesión</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Datos Empresariales</h1>
				
				<div class="datosEmpresa">
				<div><h4>Nombre: </h4> <h5><%= u.getEmpresa().getNombre() %></h5></div>
				<div><h4>Dirección: </h4> <h5 id="valorDireccion"><%= u.getEmpresa().getDireccion() %></h5></div>
				<div><h4>Teléfono: </h4> <h5 id="valorTelefono"><%= u.getEmpresa().getTelefono() %></h5></div>
				<div><h4>Contacto: </h4> <h5 id="valorContacto"><%= u.getEmpresa().getContacto() %></h5></div>
				
			<% 
			int estado=u.getEmpresa().getEstado();
			String est="";
		    if(estado==1){est="Activo";}else{est="Inactivo";}
			%>
				<div><h4>Estado: </h4><h5> <%= est %></h5></div>
				</div>
						
			<% if(u.getTipo().getId() == 2){ %>	
				<button value="Editar" onclick="habilitar()">Editar</button>

						<form  onsubmit="return validar(this);" action="/empresa" method="post" style="display:none" id="formEmpresa">
							
						    <div>Dirección: <input type="text" name="direccion" id="dirEmpresa" required="required"></input></div>
						    <div>Teléfono: <input type="tel" name="telefono" id="telEmpresa" required="required"></input></div>
						    <div>Contacto: <input type="text" name="contacto" id="conEmpresa" required="required"></input></div>
						    <div><input type="submit" value="Guardar"/><input type="reset" value="Cancelar" onclick="deshabilitar()"/></div>
						  </form>
						  
			 <% } %>
			</div>	
	
		</div>
	</div>

<%} %>

  </body>
</html>