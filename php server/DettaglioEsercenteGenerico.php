<?php	
	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue';
	
	$identificativo=$_GET['id'];
	
	// Connect to the database server   
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select the json database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	
		// Create an array to hold our results
	$arr = array();
		//Execute the query
	
	$sql="SELECT Insegna_Esercente,Indirizzo_Esercente, Citta_Esercente, Email_Esercente, Zona_Esercente,Telefono_Esercente,Giorno_chiusura_Esercente,esercente.Url_Esercente, Latitudine,Longitudine						  
	FROM esercente
	WHERE
	esercente.IDesercente='$identificativo';";
	
	$rs = mysql_query($sql) or die(mysql_error());
		
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	
	?>