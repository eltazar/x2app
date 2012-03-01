<?php

	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue'; 
	
	$lat=$_GET['lat'];
	$long=$_GET['long'];
	$tipo=$_GET['ordina'];
	$citta=$_GET['prov'];
	$giorno=$_GET['giorno'];
	$from=$_GET['from']; 
	$to=$_GET['to']; 

	//imposto il giorno per la query
	if (strcmp($giorno,"Lunedi")==0) {
		$mat="contratto_esercente.Lunedi_mat_CE";
		$sera="contratto_esercente.Lunedi_sera_CE";
	}
	else {
		if (strcmp($giorno,"Martedi")==0) {
			$mat="contratto_esercente.Martedi_mat_CE";
			$sera="contratto_esercente.Martedi_sera_CE";
		}
		else {		
			if (strcmp($giorno,"Mercoledi")==0) {
				$mat="contratto_esercente.Mercoledi_mat_CE";
				$sera="contratto_esercente.Mercoledi_sera_CE";
				}
			else {
				if (strcmp($giorno,"Giovedi")==0) {
				$mat="contratto_esercente.Giovedi_mat_CE";
				$sera="contratto_esercente.Giovedi_sera_CE";
				}
				else {
					if (strcmp($giorno,"Venerdi")==0) {
						$mat="contratto_esercente.Venerdi_mat_CE";
						$sera="contratto_esercente.Venerdi_sera_CE";
						}
					else {	
						if (strcmp($giorno,"Sabato")==0) {
							$mat="contratto_esercente.Sabato_mat_CE";
							$sera="contratto_esercente.Sabato_sera_CE";
						}
						else {
							if (strcmp($giorno,"Domenica")==0) {
								$mat="contratto_esercente.Domenica_mat_CE";
								$sera="contratto_esercente.Domenica_sera_CE";
							}
						}
					}
				}
			}
		}
	}
	// Connect to the database server   
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	// Create an array to hold our results
	$arr = array();
	//Execute the query
	if($citta=='Qui') {
	if($tipo=='distanza') {
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					  FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')
	                  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
					  ORDER BY Distanza
					  LIMIT $from,$to;";
		}
	
	if($tipo=='prezzo'){
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					  FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')
	                  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL
					  AND esercente.Fasciaprezzo_Esercente IS NOT NULL	
					  ORDER BY esercente.Fasciaprezzo_Esercente
					 LIMIT $from,$to;";
		
		}
	
		if($tipo=='nome'){
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					  FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')
	                  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
					  ORDER BY esercente.Insegna_Esercente
					 LIMIT $from,$to;";
		}		  
	
	}
	
	else {
		if($tipo=='distanza') {
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente,wrp_province
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')

					  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
					  ORDER BY Distanza
					  LIMIT $from,$to;";
					  		}
	
	if($tipo=='prezzo'){
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					  FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente,wrp_province
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')
					  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
					  AND esercente.Fasciaprezzo_Esercente IS NOT NULL	
					  ORDER BY esercente.Fasciaprezzo_Esercente
					  LIMIT $from,$to;";
		}
	
	if($tipo=='nome'){
					  $sql="SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
					 FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente,wrp_province
					  WHERE	
					  esercente.Attivo_Esercente='1'
					  AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
					  AND Latitudine <> '0'
					  AND Longitudine <> '0'
					  AND ($mat='1' OR $sera='1')
					  AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
					  AND attivita_esercente.IDesercente = esercente.IDesercente
					  AND esercente.IDesercente=contratto_esercente.IDesercente
					  AND attivita_esercente.IdTipologia_Esercente IN ('5','6','59','60','61')
					  AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')
					  AND esercente.Insegna_Esercente IS NOT NULL
					  AND esercente.Indirizzo_Esercente IS NOT NULL	
					  ORDER BY esercente.Insegna_Esercente
					  LIMIT $from,$to;";
		}
	}	
	
	$rs = mysql_query($sql) or die(mysql_error());
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
?>