<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>

<html>
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
    "SELECT * FROM empresa");
%>

<table style="border: 1px solid black">
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
 %>
<tr>
	<td><%= id %></td>
	<td><%= nombre %></td>
	<td><%= direccion %></td>
	<td><%= telefono %></td>
	<td><%= contacto %></td>
	<td><%= estado %></td>
</tr>
<%
}
conn.close();
%>

</tbody>
</table>

<p><strong>DATOS DE LA EMPRESA</strong></p>
<form action="/empresa" method="post">
    <div>Nombre: <input type="text" name="nombre"></input></div>
    <div>Dirección: <input type="text" name="direccion"></input></div>
    <div>Teléfono: <input type="text" name="telefono"></input></div>
    <div>Contacto: <input type="text" name="contacto"></input></div>
    <div>Estado:
    	<select name=estado>
    		<option seleted value=1>Activo</option>
    		<option value=0>Inactivo</option>
    		</select> 
	</div>
   
    <div><input type="submit" value="Guardar" /></div>
    <input type="hidden" name="guestbookName" />
  </form>
  </body>
</html>