<?php

	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue';
	
	

	
    $nome=str_replace("-"," ",$nome); //rimpiazzo il carattere speciale con uno spazio
    $nome = addslashes($nome);
        
	// Connect to the database server   
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	
	// Create an array to hold our results
	$arr = array();
	//Execute the query


	$sql="SELECT DISTINCT provincia
					  FROM esercente,contratto_esercente,wrp_province
					  WHERE	
					  wrp_province.sigla=esercente.Provincia_Esercente
					  AND esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  
					  ;";
	
	$rs = mysql_query($sql) or die(mysql_error());
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	/*
					  
					  	$sql="SELECT esercente.IDesercente,indirizzo_esercente,citta_esercente,insegna_esercente
					  FROM esercente,contratto_esercente
					  WHERE	
					   esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND Latitudine='0'
					  
					  ;";*/
?>
