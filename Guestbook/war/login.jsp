<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Inicio de Sesión</title>
  </head>

  <body>
    <h1>Inicar Sesión!</h1>
	
    <form action="/validar" method="post">
		<input type="mail" name="txtEmail" placeholder="E-mail" required="required"/></br>
		<input type="password" name="txtPassword" placeholder="Contraseña" required="required"/></br>
		<input type="submit" value="Iniciar Sesión"/></br>
	</form>
	<a href="#">¿Olvidaste tu contraseña?</a> 
  </body>
</html>
