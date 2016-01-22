<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.analixdata.modelos.Servicio" %>

<html>
<HEAD>

	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
	
	
	$(function() {
	    $('#empresa').on('change', function(event) {
	    	document.getElementById("btnContinuar").click();
	    });
	});
	
		
		
	</SCRIPT> 
   </HEAD>

  <body>

<%
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


<form  action="/asignarServicioUsuario">

<div>Seleccione una empresa:
	<select name=empresa id="empresa" > 
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
	</select><input type="submit" value="Continuar" name="btnContinuar" id="btnContinuar"/>
	</div>

	<%
		
	
		if(!(session.getAttribute("listaUsuarios") == null)){
			
		List<Usuario> lista= (List<Usuario>)session.getAttribute("listaUsuarios");
		
	%>
			<div>Seleccione un usuario:
			<select name=usuario id="usuario">
				<% 
				for( Usuario u:lista) {
				%>
					<option value=<%= u.getId() %>><%= u.getNombres() %></option>
				<%
					}
				%>
    		</select> 
			
	<% 	
		}
	%>	
	</div>
	
	<%
		if(!(session.getAttribute("listaServicios") == null)){
			
		List<Servicio> listaS= (List<Servicio>)session.getAttribute("listaServicios");
		
	%>
			<div>Seleccione un servicio:
			<select name=servicio id="servicio">
				<% 
				for( Servicio ser:listaS) {
				%>
					<option value=<%= ser.getIdServicio() %>><%= ser.getDescripcion() %></option>
				<%
					}
				%>
    		</select> 
			
	<% 	
		}
	%>	
	</div>
    
    

<div><input type="submit" value="Guardar" name="btnGuardar"/> </div>
	<%

		conn.close();
		
		if(!(session.getAttribute("confirmacion") == null)){
			if(session.getAttribute("confirmacion") == "1"){
			%>
				<div><h3>Servicio asignado exitosamente.</h3></div>
			<%
			}
			}
	
	%>


  </form>
  </body>
</html>