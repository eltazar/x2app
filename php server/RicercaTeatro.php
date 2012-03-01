<?php

	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue';
	
	
	$nome=$_GET['chiave'];
    $lat=$_GET['lat'];
	$long=$_GET['long'];
	$nome=str_replace("-"," ",$nome);
	$nome = addslashes($nome);
	
	// Connect to the database server   
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	
	// Create an array to hold our results
	$arr = array();
	//Execute the query


	$sql= "SELECT DISTINCT(esercente.IDesercente),Indirizzo_Esercente,esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					FROM esercente,contratto_esercente, attivita_esercente
					WHERE
					esercente.Attivo_Esercente='1'
					AND contratto_esercente.IDesercente=esercente.IDesercente							
					AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					AND ( (esercente.Insegna_Esercente LIKE '%{$nome}%')OR (esercente.Indirizzo_Esercente LIKE '%{$nome}%') OR (esercente.Zona_Esercente LIKE '%{$nome}%') )		
					AND esercente.IDesercente=attivita_esercente.IDesercente
					AND attivita_esercente.IdTipologia_Esercente ='24' 					  
					AND Latitudine <> '0'
					AND Longitudine <> '0'
					ORDER BY Distanza
  					LIMIT 20;";
	
	$rs = mysql_query($sql) or die(mysql_error());
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
?>