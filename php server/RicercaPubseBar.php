<?php

	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue';
	
	
	$nome=$_GET['chiave'];
    $lat=$_GET['lat'];
	$long=$_GET['long'];
	
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


	$sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine,esercente.Zona_Esercente,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza 
					  FROM esercente, attivita_esercente,contratto_esercente,tipologia_esercente
					  WHERE	
					  ((esercente.Insegna_Esercente LIKE '%{$nome}%')OR (esercente.Indirizzo_Esercente LIKE '%{$nome}%') OR (esercente.Zona_Esercente LIKE '%{$nome}%') )
					  AND esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('2','9','27','61')
	                  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
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
