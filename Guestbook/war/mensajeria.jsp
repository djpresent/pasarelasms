<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.analixdata.modelos.Usuario" %>
<%@ page import="com.google.appengine.api.utils.SystemProperty" %>
<%@ page import="java.sql.*" %>

<html>
  <head>
  
  	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
  	<link rel="stylesheet" type="text/css" href="css/estilos.css">
   

	<script type=text/javascript>
	
	var csv;
		function cuenta()
		{
			document.getElementById("caracteres").value=160-document.getElementById("idTexto").value.length;
			
		}
		
		function handleFiles(files) 
		{
		      // Check for the various File API support.
			if (window.FileReader) {
				getAsText(files[0]);
			} else 
			{
		    	alert('Su navegador no le permite subir archivos.');
			}
		}
		
		function getAsText(fileToRead) 
		{
			var reader = new FileReader();
			// Read file into memory as UTF-8      
		  	reader.readAsText(fileToRead);
		 	// Handle errors load
		 	reader.onload = loadHandler;
			reader.onerror = errorHandler;
		}
		
		function loadHandler(event) 
		{
			 csv = event.target.result;
			//processData(csv);
		}
		
		function errorHandler(evt) 
		{
			if(evt.target.error.name == "NotReadableError") 
			{
		 		alert("No fue posible leer el archivo!");
		  	}
		}

	    function processData() 
	    {
	    	
	    
	    	var cadenaMensajes="{\"messages\":[";
	    	var remitente="InfoSMS";
	    	var mensaje= document.getElementById("idTexto").value;
	        var allTextLines = csv.split(/\r\n|\n/);
	        if(document.getElementById("cantDisponibles").value>=allTextLines.length){
	        	
	        	document.getElementById("cantSMS").value=allTextLines.length;
	        
	        
	      //  var lines = [];
	        for (var i=0; i<allTextLines.length; i++)
	        {
	            var data = allTextLines[i].split(';');
	                //var tarr = [];
	                var destino = data[0];
	                var variable1 = data[1];
	                var variable2 = data[2];
	                var variable3 = data[3];
	                var variable4 = data[4];
	                
	                if (typeof variable1 === 'undefined')
	                {
	                	variable1=""
	                }
	                if (typeof variable2 === 'undefined')
	                {
	                	variable2=""
	                }
	                if (typeof variable3 === 'undefined')
	                {
	                	variable3=""
	                }
	                if (typeof variable4 === 'undefined')
	                {
	                	variable4=""
	                }
	                

	                var res = mensaje.replace(/\[VARIABLE1\]/g, variable1);
	                res = res.replace(/\[VARIABLE2\]/g, variable2);
	                res = res.replace(/\[VARIABLE3\]/g, variable3);
	                res = res.replace(/\[VARIABLE4\]/g, variable4);
	                
	             	if (i>0)
	             	{	
	             		cadenaMensajes+=",";
	             		
	             	}
	                	cadenaMensajes+="{\"from\":\""+remitente+"\",\"to\":\""+destino+"\",\"text\":\""+res+"\"}"; 

	          
	                	
	        }
	        cadenaMensajes+="]}";
	        document.getElementById("mensaje").value=cadenaMensajes;
	    	alert(cadenaMensajes);
	    	
	    	}else{
	    		
	    		alert("No hay suficientes mensajes disponibles en su cuenta.");
	    	}
	    }

	    function agregarV(variable)
	    {
	    	document.getElementById("idTexto").value += variable;
	    	document.getElementById("idTexto").focus();
	    }
	    

		
	</script> 
  
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Envío de Mensajes</title>
  </head>

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
    "SELECT disponible FROM servicio_empresa where idservicio=1 and idempresa="+u.getEmpresa().getIdEmpresa()+";");
 
String disponible="N/D";

if(rs.next()){
 disponible=Integer.toString(rs.getInt("disponible"));
 
 
}
else
{
	disponible="0";
}

session.setAttribute("disponibles",disponible );
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
				<h1 class="page-header">Servicio de Mensajería SMS</h1>
				<h4>SMS disponibles: <%= disponible %></h4>

			  	<form  action="enviarSMS" enctype="multipart/form-data" method="post" >
			  		<table>
			  		
			  		<tr>
			  			<td>Archivo:</td>
						
			  			<td><input type="file" name="archivo" onchange="handleFiles(this.files)" accept=".csv,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/plain" required="required"  /></td>
					</tr>
					<tr>
			  				<td>Mensaje:</td>
			  				<td>
			  					<textarea cols="40" rows="5" name="mensaje" id="idTexto" required="required" onKeyDown="cuenta()" onKeyUp="cuenta()"></textarea>
			  				</td>
			  				<td>
			  					<input type="button" onclick="agregarV('[VARIABLE1]')" value="Variable 1"></input></br>
					  			<input type="button" onclick="agregarV('[VARIABLE2]')" value="Variable 2"></input></br>
					  			<input type="button" onclick="agregarV('[VARIABLE3]')" value="Variable 3"></input></br>
					  			<input type="button" onclick="agregarV('[VARIABLE4]')" value="Variable 4"></input></br>
			  				</td>
			  			</tr>
			  			<tr>
			  				<td>Caracteres:</td>
			  				<td><input type="text" name=caracteres id="caracteres" size=4 value="160"></td>
			  			</tr>
			  		
			  			<tr>
			  				
			  				<td><input type="hidden" id="mensaje" name="txtmensaje" ></input></td>
			  				<td>
			  				<input type="hidden" id="cantDisponibles" value="<%= disponible %>"/>
			  				<input type="hidden" id="cantSMS" />
			  				<input type="submit" value="Enviar" /></td>
			  			</tr>
			  		</table>
			  	</form>
			  	
			  	<%
					if(!(session.getAttribute("codigo") == null))
					{
					
						if(session.getAttribute("codigo").toString().equalsIgnoreCase("ENVIADOS"))
						{
							
						String cod= "MENSAJES ENVIADOS SATISFACTORIAMENTE";
						
						
					%>
						<div>
							<p class="bg-success">
								<%= cod %>
							</p>
				    	</div>
							
					<% 	
						}
						else
						{
							String cod= "LOS MENSAJES NO HAN SIDO ENVIADOS. El NUMERO DE MENSAJES ES SUPERIOR A LOS MENSAJES DISPONIBLES. POR FAVOR CONTACTARSE CON ANALIXDATA";
							%>
							
							<div>
								<p class="bg-danger">
									<%= cod %>
								</p>        
				    		</div>
							
							<% 
						}
					}
				%>
			</div>	
	
		</div>
	</div>
  
  	
  	<%} %>
  </body>
</html>