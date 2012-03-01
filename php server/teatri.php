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
		$giorno="luned";
	}
	else {
		if (strcmp($giorno,"Martedi")==0) {
				$giorno="marted";
		
		}
		else {		
			if (strcmp($giorno,"Mercoledi")==0) {
					$giorno="mercoled";
				}
			else {
				if (strcmp($giorno,"Giovedi")==0) {
					$giorno="gioved";
				
				}
				else {
					if (strcmp($giorno,"Venerdi")==0) {
								$giorno="venerd";
						}
					else {	
						if (strcmp($giorno,"Sabato")==0) {
								$giorno="sabato";
						
						}
						else {
							if (strcmp($giorno,"Domenica")==0) {
										$giorno="domenica";												
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
				$sql="SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente,esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza	
				FROM esercente, contratto_esercente, attivita_esercente,t_orari_spettacoli
				WHERE
				esercente.Attivo_Esercente='1'
				AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
				AND contratto_esercente.IDcontratto_Contresercente=t_orari_spettacoli.IDcontratto_Contresercente
				AND contratto_esercente.IDesercente=esercente.IDesercente
				AND t_orari_spettacoli.giorno_della_settimana  LIKE '{$giorno}%'	
				AND esercente.IDesercente=attivita_esercente.IDesercente
				AND attivita_esercente.IdTipologia_Esercente='24'  					  
				AND Latitudine <> '0'
				AND Longitudine <> '0'
		 		ORDER BY Distanza
				LIMIT $from,$to;";
			}	
			if($tipo=='nome') {
				$sql="SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente,esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza	
				FROM esercente, contratto_esercente, attivita_esercente,t_orari_spettacoli
				WHERE
				esercente.Attivo_Esercente='1'
				AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
				AND contratto_esercente.IDcontratto_Contresercente=t_orari_spettacoli.IDcontratto_Contresercente
				AND contratto_esercente.IDesercente=esercente.IDesercente
				AND t_orari_spettacoli.giorno_della_settimana  LIKE '{$giorno}%'	
				AND esercente.IDesercente=attivita_esercente.IDesercente
				AND attivita_esercente.IdTipologia_Esercente='24'  					  
				AND Latitudine <> '0'
				AND Longitudine <> '0'
				ORDER BY esercente.Insegna_Esercente
				LIMIT $from,$to;";
			}
	}
	else {
				if($tipo=='distanza') {
				$sql="SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente, esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
				FROM esercente,contratto_esercente,attivita_esercente,wrp_province, t_orari_spettacoli
				WHERE
				esercente.Attivo_Esercente='1'
				AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
				AND contratto_esercente.IDcontratto_Contresercente=t_orari_spettacoli.IDcontratto_Contresercente
				AND contratto_esercente.IDesercente=esercente.IDesercente
				AND t_orari_spettacoli.giorno_della_settimana  LIKE '{$giorno}%'			
				AND esercente.IDesercente=attivita_esercente.IDesercente
				AND attivita_esercente.IdTipologia_Esercente='24' 	  			 					  
				AND Latitudine <> '0'
				AND Longitudine <> '0'
				AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')
		 		ORDER BY Distanza
			LIMIT $from,$to;";
			}	
			if($tipo=='nome') {
				$sql="SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente, esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza
				FROM esercente,contratto_esercente,attivita_esercente,wrp_province, t_orari_spettacoli
				WHERE
				esercente.Attivo_Esercente='1'
				AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
				AND contratto_esercente.IDcontratto_Contresercente=t_orari_spettacoli.IDcontratto_Contresercente
				AND contratto_esercente.IDesercente=esercente.IDesercente
				AND t_orari_spettacoli.giorno_della_settimana  LIKE '{$giorno}%'			
				AND esercente.IDesercente=attivita_esercente.IDesercente
				AND attivita_esercente.IdTipologia_Esercente='24' 	  			 					  
				AND Latitudine <> '0'
				AND Longitudine <> '0'
				AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')
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