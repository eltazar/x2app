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
    
    if ($ordina !== "nome" && $ordina !== "distanza" && $ordina !== "prezzo") {
        die("Invalid value for parameter 'ordina'");
    }

    
	
    //imposto il giorno per la query
	$mat = "contratto_esercente.{$giorno}_mat_CE";
    $sera = "contratto_esercente.{$giorno}_sera_CE";


    //imposto la categoria
    if ($categ === "ristoranti") {
        $categ = "IN ('5', '6', '59', '60', '61')";
    } else if ($categ === "pubsebar") {
        $categ = "IN('2', '9', '27', '61')";
    } else {
        die ("Invalid value for parameter 'categ'");
    }

    
    //impostazione mattoni query:
    $select_clause = "SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza ";
    
    $from_clause = " FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente ";
    
    $from_city_clause = ", wrp_province ";
    
    $where_clause = <<<WHE
        WHERE esercente.Attivo_Esercente='1'
        AND DATEDIFF(contratto_esercente.Data_scadenza_Contresercente,NOW())>='0'
        AND Latitudine <> '0'
        AND Longitudine <> '0'
        AND tipologia_esercente.IDtipologiaEsercente=attivita_esercente.IdTipologia_Esercente
        AND attivita_esercente.IDesercente = esercente.IDesercente
        AND esercente.IDesercente=contratto_esercente.IDesercente
        AND attivita_esercente.IdTipologia_Esercente $categ
        AND esercente.Insegna_Esercente IS NOT NULL
        AND esercente.Indirizzo_Esercente IS NOT NULL
WHE;
    
    $where_day_clause = " AND ($mat='1' OR $sera='1') ";
    
    $where_name_clause = " AND ((esercente.Insegna_Esercente LIKE '%{$chiave}%')OR (esercente.Indirizzo_Esercente LIKE '%{$chiave}%') OR (esercente.Zona_Esercente LIKE '%{$chiave}%') ) ";
    
    $where_city_clause = " AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta') ";
    
    $where_price_clause = " AND esercente.Fasciaprezzo_Esercente IS NOT NULL ";
    
    $limit_clause = " LIMIT $from, 20; ";
    
    
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
    } else if ($ordina === "prezzo") {
        $query .= $where_price_clause;
        $query .= "ORDER BY esercente.Fasciaprezzo_Esercente ";
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

	
    if ($request === "search") {    // è una ricerca
        $response = '{"Esercente:Search":'.$json_result.'}';
    } else if ($from == 0) {
        $response = '{"Esercente:FirstRows":'.$json_result.'}';
    } else {
        $response = '{"Esercente:MoreRows":'.$json_result.'}';
    }
    
	echo $response;
    
    
    
    
    
