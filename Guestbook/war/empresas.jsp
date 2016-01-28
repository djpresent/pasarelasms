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
		
			if (formObj.nombre.value == ""){
			alert("Datos imcompletos");
			return false;
			}else if (formObj.direccion.value == ""){
				alert("Datos imcompletos");
				return false;
				}else if (formObj.telefono.value == ""){
					alert("Datos imcompletos");
					return false;
					}else if (formObj.telefono.value == ""){
						alert("Datos imcompletos");
						return false;}else return true;
			}
		
		function obtenerDatos(el) {
			document.getElementById("idEmpresa").value = el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("nombreEmpresa").value= el.parentNode.parentNode.cells[1].textContent;
			document.getElementById("direccionEmpresa").value = el.parentNode.parentNode.cells[2].textContent;
			document.getElementById("telefonoEmpresa").value = el.parentNode.parentNode.cells[3].textContent;
			document.getElementById("contactoEmpresa").value = el.parentNode.parentNode.cells[4].textContent;
			
			if(el.parentNode.parentNode.cells[5].textContent == "Activo")
			 	document.getElementById("estadoEmpresa").value = 1 ;
			else
				document.getElementById("estadoEmpresa").value = 0 ;
			   
			   
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
						<li><a href="empresas.jsp">Empresas</a></li>
						<li ><a href="servicios.jsp">Servicios</a></li>
						<li><a href="usuarios.jsp">Usuarios</a></li>
						
						<%  
							if(u != null){
								
								int tipo=u.getTipo().getId();
								
								if(tipo == 1){ 
								%>
									<li ><a href="servicioEmpresa.jsp">Servcios a empresas</a></li>
									<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
								<%}
								
								if(tipo == 2){ 
									%>
										<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
									<%}
								
							}
						%>
						
						<li><a href="mensajeria.jsp">Mensajería</a></li>
						<li><a href="mensajeria.jsp">Reportes</a></li>
						<li><a href="/cerrarSesion">Cerrar Sesión</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Empresas</h1>
				<table style="border: 1px solid black" id="datosEmpresas">
						<tbody>
						<tr>
						<th width="35%" style="background-color: #CCFFCC; margin: 5px">ID</th>
						<th style="background-color: #CCFFCC; margin: 5px">Nombre</th>
						<th style="background-color: #CCFFCC; margin: 5px">Direccion</th>
						<th style="background-color: #CCFFCC; margin: 5px">Teléfono</th>
						<th style="background-color: #CCFFCC; margin: 5px">Contácto</th>
						<th style="background-color: #CCFFCC; margin: 5px">Estado</th>
						</tr>
						
						<%
						while (rs.next()) {
						    int id =rs.getInt("idempresa");
							String nombre = rs.getString("nombre");
						    String direccion = rs.getString("direccion");
						    String telefono = rs.getString("telefono");
						    String contacto = rs.getString("contacto");
						    int estado = rs.getInt("estado");
						    String est="";
						    if(estado==1){est="Activo";}else{est="Inactivo";};
						 %>
						<tr>
							<td><%= id %></td>
							<td><%= nombre %></td>
							<td><%= direccion %></td>
							<td><%= telefono %></td>
							<td><%= contacto %></td>
							<td><%= est %></td>
							<td><button class="btnEditar" type="button" onclick="obtenerDatos(this);" >Editar</button></td>
						</tr>
						<%
						}
						conn.close();
						%>
						
						</tbody>
						</table>
						
						<p><strong>DATOS DE LA EMPRESA</strong></p>
						<form  onsubmit="return validar(this);" action="/empresa" method="post">
							<div><input type="hidden" name="identificador" id="idEmpresa" ></input></div>
						    <div>Nombre: <input type="text" name="nombre" id="nombreEmpresa" required="required"></input></div>
						    <div>Dirección: <input type="text" name="direccion" id="direccionEmpresa" required="required"></input></div>
						    <div>Teléfono: <input type="tel" name="telefono" id="telefonoEmpresa" required="required"></input></div>
						    <div>Contacto: <input type="text" name="contacto" id="contactoEmpresa" required="required"></input></div>
						    <div>Estado:
						    	<select name=estado id="estadoEmpresa">
						    		<option seleted value=1>Activo</option>
						    		<option value=0>Inactivo</option>
						    		</select> 
							</div>
						    <div><input type="submit" value="Guardar"/><input type="reset" value="Cancelar"/></div>
						  </form>
			</div>	
	
		</div>
	</div>



  </body>
</html>