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
	
	$sql="SELECT distinct(contratto_esercente.IDcontratto_Contresercente), esercente.Insegna_Esercente,esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Email_Esercente, esercente.Zona_Esercente,tipologia_esercente.Tipo_Teser,esercente.Telefono_Esercente,esercente.Giorno_chiusura_Esercente,esercente.Url_Esercente,contratto_esercente.Note_Varie_CE,Latitudine,Longitudine						  
	FROM esercente,attivita_esercente, tipologia_esercente, contratto_esercente
	WHERE
	esercente.IDesercente=contratto_esercente.IDesercente
	AND esercente.IDesercente=attivita_esercente.IDesercente
	AND attivita_esercente.IdTipologia_Esercente=tipologia_esercente.IDtipologiaEsercente
	AND esercente.IDesercente='$identificativo';";
	
	$rs = mysql_query($sql) or die(mysql_error());
		
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	
	?>