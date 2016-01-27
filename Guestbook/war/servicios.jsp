<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="com.analixdata.modelos.Usuario" %>

<html>
<HEAD>

	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
	<SCRIPT type=text/javascript>
		
		function obtenerDatos(el) {
			document.getElementById("idServicio").value = el.parentNode.parentNode.cells[0].textContent;
			document.getElementById("descServicio").value= el.parentNode.parentNode.cells[1].textContent;			   
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
    "SELECT * FROM servicio");
%>

<table style="border: 1px solid black" id="datosSeervicios">
<tbody>
<tr>
<th width="35%" style="background-color: #CCFFCC; margin: 5px">ID</th>
<th style="background-color: #CCFFCC; margin: 5px">Descripcion</th>

</tr>

<%
while (rs.next()) {
    int id =rs.getInt("idservicio");
	String descripcion = rs.getString("descripcion");

 %>
<tr>
	<td><%= id %></td>
	<td><%= descripcion %></td>
	<td><button class="btnEditar" type="button" onclick="obtenerDatos(this);" >Editar</button></td>
</tr>
<%
}
conn.close();
%>

</tbody>
</table>

<p><strong>DATOS DEL SERVICIO</strong></p>
<form  action="/servicio" method="post">
	<div><input type="hidden" name="identificador" id="idServicio" ></input></div>
    <div>Descripción: <input type="text" name="descripcion" id="descServicio" required="required"></input></div>

    <div><input type="submit" value="Guardar"/><input type="reset" value="Cancelar"/></div>
  </form>
  </body>
</html>