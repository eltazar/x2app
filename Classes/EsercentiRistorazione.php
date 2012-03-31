<?php
    
    /**
     * Invia esercenti 
     *
     * @author Gabriele "Whisky" Visconti
     *
     **/
    
    include 'QueryHelper.php'
	
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
    
    
	
    //imposto il giorno per la query
	$mat = "contratto_esercente.$giorno_mat_CE";
    $mat = "contratto_esercente.$giorno_sera_CE";


    //imposto la categoria
    if (!strcmp($categ, "ristoranti")) {
        $categ = "IN ('5', '6', '59', '60', 61')";
    } else if (!strcmp($categ, "pubsebar")) {
        $categ = "IN('2', '9', '27', '61')";
    } 

    
    //impostazione mattoni query:
    $select_clause = "SELECT DISTINCT(esercente.IDesercente),esercente.Indirizzo_Esercente,esercente.Citta_Esercente,esercente.Insegna_Esercente,Tipo_Teser,esercente.Fasciaprezzo_Esercente,Latitudine,Longitudine, (ACOS(SIN(RADIANS('$lat'))*SIN(RADIANS(Latitudine))+COS(RADIANS(Latitudine))*COS(RADIANS('$lat'))*COS(ABS(RADIANS('$long')-RADIANS(Longitudine))))*6371) as Distanza";
    
    $from_clause = "FROM esercente, attivita_esercente,contratto_esercente, tipologia_esercente, wrp_province";
    
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
    
    $where_day_clause = " AND ($mat='1' OR $sera='1')";
    
    $where_name_clause = " AND ((esercente.Insegna_Esercente LIKE '%{$nome}%')OR (esercente.Indirizzo_Esercente LIKE '%{$nome}%') OR (esercente.Zona_Esercente LIKE '%{$nome}%') )";
    
    $where_city_clause = "AND (esercente.Provincia_Esercente=wrp_province.sigla AND wrp_province.provincia='$citta')";
    
    $where_price_clause = "AND esercente.Fasciaprezzo_Esercente IS NOT NULL";
    
    
    // costruzione query
    $query = $select_clause.$from_clause.$where_clause;
    
    if (strcmp($citta, "")) {   // se città NON è vuoto.
        $query = $query.$where_city_clause;
    }
    
    if (strcmp($nome, "")) {    // se nome NON è vuoto.
        $query = $query.$where_name_clause;
    }
    
    if (strcmp($giorno, "")) {  // se giorno NON è vuoto.
        $query = $query.$where_day_clause;
    }    
        
    
    if (!strcmp($ordina, "prezzo")) {
        $query = $query.$where_price_clause."ORDER BY esercente.Fasciaprezzo_Esercente";
    } else if (!strcmp($ordina, "distanza")) {
        $query = $query."ORDER BY Distanza "; 
    } else if (!strcmp($ordina, "nome")) {
        $uery = $query."ORDER BY esercente.Insegna_Esercente ";
    }
    
    $query = $query.$limit_clause;
        
    
    // esecuzione query    
    $qh = new QueryHelper();
	
    $json_result = $qh->query($query);
	
    if ( strcmp($nome, "")) {    // è una ricerca
        $response = '{"Esercente:Search":'.$json_result.'}';
    } else if ($from == 0) {
        $response = '{"Esercente:FirstRows":'.$json_result.'}';
    } else {
        $response = '{"Esercente:MoreRows":'.$json_result.'}';
    }
    
	echo $response;
    
    
    
    
    
