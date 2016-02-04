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
	
			function obtenerDatos(el) {
				document.getElementById("idServicio").value= el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("servicio").value= el.parentNode.parentNode.cells[1].textContent;
			document.getElementById("limite").value = el.parentNode.parentNode.cells[3].textContent;
			document.getElementById("costo").value = el.parentNode.parentNode.cells[4].textContent;

			if(el.parentNode.parentNode.cells[8].textContent == "Activo")
			 	document.getElementById("estado").value = 1 ;
			else
				document.getElementById("estado").value = 0 ;
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

int idempresa=u.getEmpresa().getIdEmpresa();
Connection conn = DriverManager.getConnection(url);

ResultSet rs = null;

if(u.getTipo().getId() == 2){
	rs = conn.createStatement().executeQuery(
		    "SELECT servicio_empresa.idservicio,descripcion,limite,disponible,costotransaccion,servicio_empresa.estado FROM pasarelasms.servicio_empresa,pasarelasms.servicio WHERE servicio_empresa.idservicio=servicio.idservicio and servicio_empresa.idempresa ="+idempresa+";");
}



if(u.getTipo().getId() == 3){
	int idusuario = u.getId();
	rs = conn.createStatement().executeQuery(
		    "SELECT servicio_usuario.idservicio,descripcion,limite,disponible,servicio_empresa.estado FROM pasarelasms.servicio_usuario,pasarelasms.servicio_empresa,pasarelasms.servicio WHERE servicio_usuario.idservicio=servicio_empresa.idservicio and servicio_usuario.idservicio=servicio.idservicio and servicio_usuario.idusuario ="+idusuario+" and servicio_empresa.idempresa ="+idempresa+";");
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
								<%}
								
								if(tipo == 2){ 
									%>
										<li><a href="empresa.jsp">Empresa</a></li>
										<li ><a href="serviciosContratados.jsp">Servicios</a></li>
										<li><a href="usuarios.jsp">Usuarios</a></li>
										<li><a href="servicioUsuarios.jsp">Servicios a Usuarios</a></li>
									<%}
								
								if(tipo == 3){ 
									%>
										<li><a href="empresa.jsp">Empresa</a></li>
										<li ><a href="serviciosContratados.jsp">Servicios</a></li>
										<li><a href="usuario.jsp">Usuario</a></li>
								
									<%}
								
								if(tipo == 1 || u.tieneServicio(1)){%>
								<li><a href="mensajeria.jsp">Mensajería</a></li>
								<li><a href="reportes.jsp">Reportes</a></li>
								
							<%}
								
							}
						%>
			
						<li><a href="/cerrarSesion">Cerrar Sesión</a></li>
				
					</ul>
				</div>
		
			<div class="col-sm-9 col-md-9 main">
				<h1 class="page-header">Servicios Contratados</h1>
				<table style="border: 1px solid black" id="datosServiciosC">
				<tbody>
				<tr>
				<th style="background-color: #CCFFCC; margin: 5px">ID Servicio</th>
				<th style="background-color: #CCFFCC; margin: 5px">Descripción</th>
				<th style="background-color: #CCFFCC; margin: 5px">Límite mensual</th>
				<th style="background-color: #CCFFCC; margin: 5px">Disponible</th>
				
				<%if (u.getTipo().getId()<3){ %>
				
				<th style="background-color: #CCFFCC; margin: 5px">Costo / Transacción</th>
				
				<% }%>
				
				<th style="background-color: #CCFFCC; margin: 5px">Estado</th>
				</tr>
				
				<%
				while (rs.next()) {
				    int id =rs.getInt("idservicio");
					String servicio = rs.getString("descripcion");
				    int limite = rs.getInt("limite");
				    int disponible = rs.getInt("disponible");
				    
				    float costo=0;
				    if(u.getTipo().getId() <3){
				    costo = rs.getFloat("costotransaccion");
				    }
				    
				    int estado = rs.getInt("estado"); 
				    String est="";
				    if(estado==1)est="Activo";else est="Inactivo";
				   
				 %>
				<tr>
					<td><%= id %></td>
					<td><%= servicio %></td>
					<td><%= limite %></td>
					<td><%= disponible %></td>
					
					<%if (u.getTipo().getId() < 3){ %>
					<td><%= costo %></td>
					<%} %>
					<td><%= est %></td>
				</tr>
				<%
				}
					conn.close();
					%>

				
				</tbody>
				</table>
				
				
					

			</div>	
	
		</div>
	</div>


  </body>
</html>