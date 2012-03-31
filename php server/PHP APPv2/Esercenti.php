<?php
    
    /**
     * Invia esercenti 
     *
     * @author Gabriele "Whisky" Visconti
     *
     **/
    
    include '../QueryHelper.php';
	
	$categ  = $_POST['categ'];
    $lat    = $_POST['lat'];
	$long   = $_POST['long'];
	$nome   = $_POST['chiave'];
	$citta  = $_POST['prov'];
	$giorno = $_POST['giorno'];
    $ordina = $_POST['ordina'];
    $from   = $_POST['from'];
    
	$nome = str_replace("-", " ", $nome);
	$nome = addslashes($nome);
    
    /*echo "categ: ".$categ."\n";
    echo "lat: ".$lat."\n";  
    echo "long: ".$long."\n";  
    echo "nome: ".$nome."\n";   
    echo "citta: ".$citta."\n"; 
    echo "giorno: ".$giorno."\n"; 
    echo "ordina: ".$ordina."\n"; 
    echo "from : ".$from."\n";  */
    
	 
	
    //imposto il giorno per la query
	if (!strcmp($giorno, "Lunedi")) {
		$giorno = "luned";
	} else if (!strcmp($giorno, "Martedi")) {
        $giorno = "marted";
    } else if (!strcmp($giorno, "Mercoledi")) {
        $giorno = "mercoled";
    } else if (!strcmp($giorno, "Giovedi")) {
        $giorno = "gioved";
    } else if (!strcmp($giorno, "Venerdi")) {
        $giorno = "venerd";
    } else if (!strcmp($giorno, "Sabato")) {
        $giorno = "sabato";
    } else if (!strcmp($giorno, "Domenica")) {
        $giorno = "domenica";	
    }
    
    //imposto la categoria
    if (!strcmp($categ, "cinema")) {
        $categ = "= '25'";
    } else if (!strcmp($categ, "teatri")) {
        $categ = "= '24'";
    } else if (!strcmp($categ, "musei")) {
        $categ = "= '54'";
    } else if (!strcmp($categ, "librerie")) {
        $categ = "= '51'";
    } else if (!strcmp($categ, "benessere")) {
        $categ = "IN ('50', '39')";
    } else if (!strcmp($categ, "parchi")) {
        $categ = "= '44'";
    } else if (!strcmp($categ, "viaggi")){
        $categ = "IN ('48', '56')";
    } else if (!strcmp($categ, "altro")) {
        $categ = "IN ('31', '36', '47', '49', '55', '56', '57')";
    }
    
    
    // impostazione mattoni base query
    $select_clause = "SELECT DISTINCT(esercente.IDesercente), Indirizzo_Esercente, esercente.Insegna_Esercente,Citta_Esercente, Latitudine, Longitudine,(ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza ";
    
    $from_clause = "FROM esercente,contratto_esercente, attivita_esercente, t_orari_spettacoli ";
    
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
    
    $where_name_clause = " AND ( (esercente.Insegna_Esercente LIKE '%{$nome}%') OR (esercente.Indirizzo_Esercente LIKE '%{$nome}%') OR (esercente.Zona_Esercente LIKE '%{$nome}%') )";
    
    $where_city_clause = " AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta') ";
    
    $limit_clause = "LIMIT $from, 20;";
    
    
	// costruzione query
    $query = $select_clause.$from_clause.$where_clause;
    
    if (strcmp($citta, "Qui")) {   // se città NON è "Qui".
        $query = $query.$where_city_clause;
    }
    
    if (strcmp($nome, "")) {    // se nome NON è vuoto.
        $query = $query.$where_name_clause;
    }
    
    if (strcmp($giorno, "")) {  // se giorno NON è vuoto.
        $query = $query.$where_day_clause;
    }
    
    if (!strcmp($ordina, "distanza")) {
        $query = $query."ORDER BY Distanza "; 
    } else if (!strcmp($ordina, "nome")) {
        $uery = $query."ORDER BY esercente.Insegna_Esercente ";
    }
    
    $query = $query.$limit_clause;
    
    
    // esecuzione query    
    $qh = new QueryHelper();
	
    
    // TODO: zozzata, sistemare.
    mysql_select_db("cartaperdue");
    
    $json_result = $qh->query($query);
    
    if ($json_result == '"ERROR"') {
        /*echo $qh->lastError();
        echo "<br/>\n";
        echo str_replace("\n", "<br/>\n", $query);
        echo $categ."<br/>\n";
        echo $lat."<br/>\n";  
        echo $long."<br/>\n";  
        echo $nome."<br/>\n";   
        echo $citta."<br/>\n"; 
        echo $giorno."<br/>\n"; 
        echo $ordina."<br/>\n"; 
        echo $from."<br/>\n"; */  

    }
    
    /*echo $query;*/
    
	
    if ( strcmp($nome, "")) {    // è una ricerca
        $response = '{"Esercente:Search":'.$json_result.'}';
    } else if ($from == 0) {
        $response = '{"Esercente:FirstRows":'.$json_result.'}';
    } else {
        $response = '{"Esercente:MoreRows":'.$json_result.'}';
    }
    
	echo $response;
	
	?>
