<?php
    
    /**
     * Invia esercenti 
     *
     * @author Gabriele "Whisky" Visconti
     *
     **/
    
    include '../QueryHelper.php';
	
	$request = $_POST['request'];
    $categ   = $_POST['categ'];
    $lat     = $_POST['lat'];
	$long    = $_POST['long'];
	$chiave  = $_POST['chiave'];
	$citta   = $_POST['prov'];
	$giorno  = $_POST['giorno'];
    $ordina  = $_POST['ordina'];
    $from    = $_POST['from'];
    
	$chiave = str_replace("-", " ", $chiave);
	$chiave = addslashes($chiave);
    
    // Lo script termina se il valore di request non è interpretabile.
    if ($request !== "fetch" && $request !== "search") {
        die("Invalid value for parameter 'request'");
    }
    
    if ($ordina !== "nome" && $ordina !== "distanza") {
        die("Invalid value for parameter 'ordina'");
    }
    
    /*echo "categ: ".$categ."\n";
    echo "lat: ".$lat."\n";  
    echo "long: ".$long."\n";  
    echo "chiave: ".$chiave."\n";   
    echo "citta: ".$citta."\n"; 
    echo "giorno: ".$giorno."\n"; 
    echo "ordina: ".$ordina."\n"; 
    echo "from : ".$from."\n";  */
    
	 
	
    //imposto il giorno per la query
	if ($giorno === "Lunedi") {
		$giorno = "luned";
	} else if ($giorno === "Martedi") {
        $giorno = "marted";
    } else if ($giorno === "Mercoledi") {
        $giorno = "mercoled";
    } else if ($giorno === "Giovedi") {
        $giorno = "gioved";
    } else if ($giorno === "Venerdi") {
        $giorno = "venerd";
    } else if ($giorno === "Sabato") {
        $giorno = "sabato";
    } else if ($giorno === "Domenica") {
        $giorno = "domenica";	
    } 
    
    //imposto la categoria
    if ($categ === "cinema") {
        $categ = "= '25'";
    } else if ($categ === "teatri") {
        $categ = "= '24'";
    } else if ($categ === "musei") {
        $categ = "= '54'";
    } else if ($categ === "librerie") {
        $categ = "= '51'";
    } else if ($categ === "benessere") {
        $categ = "IN ('50', '39')";
    } else if ($categ === "parchi") {
        $categ = "= '44'";
    } else if ($categ === "viaggi"){
        $categ = "IN ('48', '56')";
    } else if ($categ === "altro") {
        $categ = "IN ('31', '36', '47', '49', '55', '56', '57')";
    } else {
        die ("Invalid value for parameter 'categ'");
    }
    
    
    // impostazione mattoni base query
    $select_clause = "SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente, esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza ";
    
    $from_clause = "FROM esercente,contratto_esercente, attivita_esercente, t_orari_spettacoli ";
    
    $from_city_clause = ", wrp_province ";
    
    $where_clause = <<<WHE
        WHERE esercente.Attivo_Esercente = '1'
        AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente, NOW()) >= '0'
        AND contratto_esercente.IDcontratto_Contresercente = t_orari_spettacoli.IDcontratto_Contresercente
        AND contratto_esercente.IDesercente = esercente.IDesercente
        AND esercente.IDesercente = attivita_esercente.IDesercente
        AND attivita_esercente.IdTipologia_Esercente $categ	  			  					  
        AND Latitudine <> '0'
        AND Longitudine <> '0' 
WHE;
    
    $where_day_clause = " AND t_orari_spettacoli.giorno_della_settimana LIKE '{$giorno}%' ";
    
    $where_name_clause = " AND ( (esercente.Insegna_Esercente LIKE '%{$chiave}%') OR (esercente.Indirizzo_Esercente LIKE '%{$chiave}%') OR (esercente.Zona_Esercente LIKE '%{$chiave}%') )";
    
    $where_city_clause = " AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta') ";
    
    $limit_clause = "LIMIT $from, 20;";
    
    
	
    // costruzione query
    $query = $select_clause.$from_clause;
    
    if ($request === "search") {
        $query .= $where_clause;
        $query .= $where_name_clause;
        
        
    } else if ($request === "fetch") {
        if ($citta === "Qui" || $citta === "") {
            $query .= $where_clause;
            if ($giorno !== "") $query .= $where_day_clause;
        } else { // $citta contiene qualcosa di valido
            $query .= $from_city_clause.$where_clause.$where_city_clause;
            if ($giorno !== "") $query .= $where_day_clause;
        }
    }

    if ($ordina === "nome") {
        $query .= "ORDER BY esercente.Insegna_Esercente ";
    } else if ($ordina === "distanza") {
        $query .= "ORDER BY Distanza "; 
    }

    $query .= $limit_clause;
    
        
    // esecuzione query    
    $qh = new QueryHelper();
	
    // TODO: zozzata, sistemare.
    mysql_select_db("cartaperdue");
    
    $json_result = $qh->query($query);
    
    if ($json_result == '"ERROR"') {
        echo $qh->lastError();
        echo "<br/>\n";
        echo str_replace("\n", "<br/>", $query);
        echo "categ: ".$categ."<br/>";
        echo "lat: ".$lat."<br/>";  
        echo "long: ".$long."<br/>";  
        echo "chiave: ".$chiave."<br/>";   
        echo "citta: ".$citta."<br/>"; 
        echo "giorno: ".$giorno."<br/>"; 
        echo "ordina: ".$ordina."<br/>"; 
        echo "from: ".$from."<br/>";   

    }
    
    /*echo $query;*/
    
	
    if ($request === "search") {    // è una ricerca
        $response = '{"Esercente:Search":'.$json_result.'}';
    } else if ($from == 0) {
        $response = '{"Esercente:FirstRows":'.$json_result.'}';
    } else {
        $response = '{"Esercente:MoreRows":'.$json_result.'}';
    }
    
	echo $response;
	
	?>
