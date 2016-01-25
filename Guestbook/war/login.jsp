<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Inicio de Sesión</title>
    
     <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
  </head>

  <body>
  <div class="container-fluid">
	<div class="row">
		<div class="col-xs-6 col-md-4 col-xs-offset-3 col-md-offset-4">
	    <form action="/validar" method="post" class="form-signin">
	    	<h2 class="form-signin-heading">Bienvenido, por favor inicie sesión</h2>
	    	<label for="txtEmail" class="sr-only">E-mail</label>
			<input type="email" class="form-control" id="txtEmail" name="txtEmail" placeholder="E-mail" required="required" autofocus/>
			<label for="txtPassword" class="sr-only">Contraseña</label>
			<input type="password" class="form-control" name="txtPassword" placeholder="Contraseña" required="required"/>
			<input type="submit" class="btn btn-lg btn-primary btn-block" value="Iniciar Sesión"/>
		</form>
		<a href="#">¿Olvidaste tu contraseña?</a> 
		</div>
	</div>
	</div>
	
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
	
  </body>
</html>
