<%@ page contentType="text/html;charset=UTF-8" language="java" %>






<html>
  <head>
  
  	

	
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
	    	var remitente="1234567890";
	    	var mensaje= document.getElementById("idTexto").value;
	        var allTextLines = csv.split(/\r\n|\n/);
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
	             	
	                //alert (destino+" "+variable1+" "+variable2);
	                //alert(res);
	                //for (var j=0; j<data.length; j++) 
	                //{
	                //    tarr.push(data[j]);
	                //}
	                //lines.push(tarr);
	                
	        }
	        cadenaMensajes+="]}";
	        document.getElementById("mensaje").value=cadenaMensajes;
	        
	        
	    	//alert(cadenaMensajes);
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
  	<table>
  		<tr>
  			<td>Opción 1:</td>
			<td><input type="text" name="nombreArchivo" required="required" /></td>
  			<td><input type="file" name="archivo" onchange="handleFiles(this.files)" accept=".csv,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/plain" required="required"  /></td>
		</tr>
		<tr>
  				<td>Mensaje:</td>
  				<td>
  					<textarea cols="40" rows="5" name="mensaje" id="idTexto" required="required" onKeyDown="cuenta()" onKeyUp="cuenta()"></textarea>
  				</td>
  				<td>
  					<input type="button" onclick="agregarV(' [VARIABLE1] ')" value="Variable 1"></input></br>
		  			<input type="button" onclick="agregarV(' [VARIABLE2] ')" value="Variable 2"></input></br>
		  			<input type="button" onclick="agregarV(' [VARIABLE3] ')" value="Variable 3"></input></br>
		  			<input type="button" onclick="agregarV(' [VARIABLE4] ')" value="Variable 4"></input></br>
  				</td>
  			</tr>
  			<tr>
  				<td>Caracteres:</td>
  				<td><input type="text" name=caracteres id="caracteres" size=4 value="160"></td>
  			</tr>
  	</table>
  	<form onSubmit="processData()" action="enviarSMS" >
  		<table>
  			<tr>
  				<td><input type="hidden" id="mensaje" name="txtmensaje" ></input></td>
  				<td><input type="submit" value="Enviar" /></td>
  			</tr>
  		</table>
  	</form>
  	
  </body>
</html>