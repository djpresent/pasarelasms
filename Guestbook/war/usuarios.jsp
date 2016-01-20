<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>

<html>
<HEAD>

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
			document.getElementById("idUsuario").value = el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("cedulaUsuario").value= el.parentNode.parentNode.cells[1].textContent;
			document.getElementById("nombresUsuario").value = el.parentNode.parentNode.cells[2].textContent;
			document.getElementById("apellidosUsuario").value = el.parentNode.parentNode.cells[3].textContent;
			document.getElementById("cargoUsuario").value = el.parentNode.parentNode.cells[4].textContent;
			document.getElementById("mailUsuario").value = el.parentNode.parentNode.cells[4].textContent;
			document.getElementById("passwordUsuario").value = el.parentNode.parentNode.cells[4].textContent;
		}
		
		
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
    "SELECT * FROM usuario");
%>

<table style="border: 1px solid black" id="datosUsuarios">
<tbody>
<tr>
<th width="35%" style="background-color: #CCFFCC; margin: 5px">ID</th>
<th style="background-color: #CCFFCC; margin: 5px">Cédula</th>
<th style="background-color: #CCFFCC; margin: 5px">Nombres</th>
<th style="background-color: #CCFFCC; margin: 5px">Apellidos</th>
<th style="background-color: #CCFFCC; margin: 5px">Cargo</th>
<th style="background-color: #CCFFCC; margin: 5px">Email</th>
<th style="background-color: #CCFFCC; margin: 5px">Password</th>
</tr>

<%
while (rs.next()) {
    int id =rs.getInt("idusuario");
	String cedula = rs.getString("cedula");
    String nombres = rs.getString("nombres");
    String apellidos = rs.getString("apellidos");
    String cargo = rs.getString("cargo");
    String email = rs.getString("email");
    String password = rs.getString("password");
 %>
<tr>
	<td><%= id %></td>
	<td><%= cedula %></td>
	<td><%= nombres %></td>
	<td><%= apellidos %></td>
	<td><%= cargo %></td>
	<td><%= email %></td>
	<td><%= password %></td>
	<td><button class="btnEditar" type="button" onclick="obtenerDatos(this);" >Editar</button></td>
</tr>
<%
}
conn.close();
%>

</tbody>
</table>

<p><strong>DATOS DEL USUARIO</strong></p>
<form  onsubmit="return validar(this);" action="/usuario" method="post">
	<div><input type="hidden" name="identificador" id="idUsuario" ></input></div>
    <div>Cedula: <input type="text" name="cedula" id="cedulaUsuario" required="required"></input></div>
    <div>Nombres: <input type="text" name="nombres" id="nombresUsuario" required="required"></input></div>
    <div>Apellidos: <input type="text" name="apellidos" id="ApellidosUsuario" required="required"></input></div>
    <div>Cargo: <input type="text" name="cargo" id="cargoUsuario" required="required"></input></div>
    <div>Email: <input type="text" name="email" id="emailUsuario" required="required"></input></div>
   	<div>Contraseña: <input type="text" name="password" id="passwordUsuario" required="required"></input></div>
   	<div>Confirmar Contraseña: <input type="text" name="cpassword" id="cpasswordUsuario" required="required"></input></div>
   
    <div><input type="submit" value="Guardar"/><input type="reset" value="Cancelar"/></div>
  </form>
  </body>
</html>