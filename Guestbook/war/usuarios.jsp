<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>

<html>
<HEAD>

	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">

	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<script src="js/codificacion.js"></script>
	<SCRIPT type=text/javascript>
	

	
	function validarPass(){
		
		if(document.getElementById('divContrasena').style.display != 'none'){
		
		var caract_invalido = " ";
		var caract_longitud = 6;
		var cla1 = document.datosUsuario.password.value;
		var cla2 = document.datosUsuario.cpassword.value;
		if (cla1 == '' || cla2 == '') {
			alert('No ha ingresado la contraseña.');
			return false;
		}
		if (document.datosUsuario.password.value.length < caract_longitud) {
		alert('Su contraseña debe constar de ' + caract_longitud + ' caracteres.');
		return false;
		}
		if (document.datosUsuario.password.value.indexOf(caract_invalido) > -1) {
		alert("Las contraseñas no pueden contener espacios.");
		return false;
		}
		else {
		if (cla1 != cla2) {
		alert ("Las contraseñas introducidas no coinciden.");
		return false;
		}
		else {
			document.getElementById('divContrasena').style.display = 'block';
			document.getElementById('divContrasenaC').style.display = 'block';
			document.getElementById('passwordUsuario').value = hex_md5(document.getElementById('password').value);
			
			return true;
		      }
		   }
		}else{
			return true;
		}
		}
	

		function obtenerDatos(el) {
			document.getElementById("idUsuario").value = el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("cedulaUsuario").value= el.parentNode.parentNode.cells[1].textContent;
			document.getElementById("nombresUsuario").value = el.parentNode.parentNode.cells[2].textContent;
			document.getElementById("apellidosUsuario").value = el.parentNode.parentNode.cells[3].textContent;
			document.getElementById("cargoUsuario").value = el.parentNode.parentNode.cells[4].textContent;
			document.getElementById("telefonoUsuario").value = el.parentNode.parentNode.cells[5].textContent;
			document.getElementById("emailUsuario").value = el.parentNode.parentNode.cells[6].textContent;
			
			if(el.parentNode.parentNode.cells[7].textContent == "Activo")
			 	document.getElementById("estadoUsuario").value = 1 ;
			else
				document.getElementById("estadoUsuario").value = 0 ;
			
			document.getElementById("tipoUsuario").value = el.parentNode.parentNode.cells[8].textContent;
			
			document.getElementById('divContrasena').style.display = 'none';
			document.getElementById('divContrasenaC').style.display = 'none';
			document.getElementById('divServicios').style.display = 'none';
			
			document.getElementById("empresaUsuario").value = el.parentNode.parentNode.cells[9].textContent; 
			
			
		
		}
		
		function habilitarC(){
			
			document.getElementById('divContrasena').style.display = 'block';
			document.getElementById('divContrasenaC').style.display = 'block';
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
ResultSet rs = null;

if(u.getTipo().getId() == 1){
	rs=conn.createStatement().executeQuery(
    "SELECT idusuario,cedula,nombres,apellidos,cargo,email,usuario.telefono,password,descripcion,nombre,usuario.estado FROM pasarelasms.usuario,pasarelasms.tipo,pasarelasms.empresa WHERE usuario.idtipo=tipo.idtipo and usuario.idempresa=empresa.idempresa and usuario.idtipo >= "+u.getTipo().getId()+" and empresa.estado=1;");
}



if(u.getTipo().getId() == 2){
	int idempresa = u.getEmpresa().getIdEmpresa();
	rs=conn.createStatement().executeQuery(
    "SELECT idusuario,cedula,nombres,apellidos,cargo,email,usuario.telefono,password,descripcion,nombre,usuario.estado FROM pasarelasms.usuario,pasarelasms.tipo,pasarelasms.empresa WHERE usuario.idtipo=tipo.idtipo and usuario.idempresa=empresa.idempresa and usuario.idempresa="+idempresa+" and usuario.idtipo >= "+u.getTipo().getId()+";");
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
				<h1 class="page-header">Usuarios</h1>
				<table style="border: 1px solid black" id="datosUsuarios">
				<tbody>
				<tr>
				<th style="background-color: #CCFFCC; margin: 5px">ID</th>
				<th style="background-color: #CCFFCC; margin: 5px">Cédula</th>
				<th style="background-color: #CCFFCC; margin: 5px">Nombres</th>
				<th style="background-color: #CCFFCC; margin: 5px">Apellidos</th>
				<th style="background-color: #CCFFCC; margin: 5px">Cargo</th>
				<th style="background-color: #CCFFCC; margin: 5px">Telefono</th>
				<th style="background-color: #CCFFCC; margin: 5px">Email</th>
				<th style="background-color: #CCFFCC; margin: 5px">Estado</th>
				<th style="background-color: #CCFFCC; margin: 5px">Tipo</th>
				<th style="background-color: #CCFFCC; margin: 5px">Empresa</th>
				</tr>
				
				<%
				while (rs.next()) {
				    int id =rs.getInt("idusuario");
					String cedula = rs.getString("cedula");
				    String nombres = rs.getString("nombres");
				    String apellidos = rs.getString("apellidos");
				    String cargo = rs.getString("cargo");
				    String telefono = rs.getString("telefono");
				    String email = rs.getString("email");
				    String password = rs.getString("password");
				    int estado = rs.getInt("estado"); 
				    String est="";
				    if(estado==1)est="Activo";else est="Inactivo";
				    
				    String tipo = rs.getString("descripcion");
				    String empresa = rs.getString("nombre");
				   
				 %>
				<tr>
					<td><%= id %></td>
					<td><%= cedula %></td>
					<td><%= nombres %></td>
					<td><%= apellidos %></td>
					<td><%= cargo %></td>
					<td><%= telefono %></td>
					<td><%= email %></td>
					<td><%= est %></td>
					<td><%= tipo %></td>
					<td><%= empresa %></td>
					<td><button class="btnEditar" type="button" onclick="obtenerDatos(this);" >Editar</button></td>
				</tr>
				<%
				}
				
				rs = conn.createStatement().executeQuery("SELECT * FROM tipo");%>
				
				
				
				</tbody>
				</table>
				
				<p><strong>DATOS DEL USUARIO</strong></p>
				<form onSubmit="validarPass();" action="/usuario" method="post" name="datosUsuario">
					<div><input type="hidden" name="identificador" id="idUsuario" ></input></div>
				    <div>Cedula: <input type="text" name="cedula" id="cedulaUsuario" required="required"></input></div>
				    <div>Nombres: <input type="text" name="nombres" id="nombresUsuario" required="required"></input></div>
				    <div>Apellidos: <input type="text" name="apellidos" id="apellidosUsuario" required="required"></input></div>
				    <div>Cargo: <input type="text" name="cargo" id="cargoUsuario" required="required"></input></div>
				    <div>Teléfono: <input type="text" name="telefono" id="telefonoUsuario" required="required"></input></div>
				   	<div>Email: <input type="text" name="email" id="emailUsuario" required="required"></input></div>
				   	<div id="divContrasena">Contraseña:<input type="password" name="password" id="password"></input></div>
				   	<div><input type="hidden" id="passwordUsuario" name="passwordUsuario" ></input></div>
				   	<div id="divContrasenaC">Confirmar Contraseña: <input type="password" name="cpassword" id="cpassword"></input></div>
				    <div>Estado:
				    	<select name=estado id="estadoUsuario">
				    		<option seleted value=1>Activo</option>
				    		<option value=0>Inactivo</option>
				    		</select> 
					</div>
					<div>Tipo de usuario:
				    	<select name=tipo id="tipoUsuario">
				    		<% 
					while (rs.next()) {
						
					int idtipo = rs.getInt("idtipo");	
					if(idtipo >= u.getTipo().getId()){
					String tipoU = rs.getString("descripcion");%>
						<option value=<%= tipoU %>><%= tipoU %></option>
					<%}}%>
				    		</select> 
					</div>
					
					<div>
					<%
					
					rs = conn.createStatement().executeQuery("SELECT * FROM empresa where estado=1");
					
					List<Servicio> servicios= new ArrayList();
					
					if(u.getTipo().getId() == 1){
					%>
					
					Empresa:
					
					<select name=empresaUsuario id="empresaUsuario">
					<option value="noempresa">Seleccione una empresa</option>
					<% 
					
					
					
					
					while (rs.next()) {
					String empresa = rs.getString("nombre");%>
						<option value=<%= empresa %>><%= empresa %></option>
					<%}	
					
					}else{%>
						<input name="empresa" type="hidden" value="<%= u.getEmpresa().getNombre() %>"/>
						<div id="divServicios">
						Servicios:
						<%
						   servicios=u.getServicios();
						
							for(int i=0;i<servicios.size();i++){
								%>
								<input type="checkbox" name="<%=servicios.get(i).getDescripcion() %>" value="<%=servicios.get(i).getIdServicio() %>" checked> <%=servicios.get(i).getDescripcion() %><br>
								
							<%
							}
							
						%>
						</div>
					<%}
					conn.close();
					%>
					</div>
				    <div>
				    <input type="submit" value="Guardar" name="btnGuardar"/>
				    <input type="reset" value="Cancelar" onclick="habilitarC()"/></div>
				  </form>
			</div>	
	
		</div>
	</div>

  </body>
</html>