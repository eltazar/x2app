<?php
    
    /**
     * Invia esercenti 
     *
     * @author Gabriele "Whisky" Visconti
     *
     **/
    
    include '../QueryHelper.php';
	
	$request = $_POST['request'];
    $lat     = $_POST['lat'];
	$long    = $_POST['long'];
	$chiave  = $_POST['chiave'];
	$citta   = $_POST['prov'];
	$giorno  = $_POST['giorno'];
    $raggio  = $_POST['raggio'];
    $ordina  = $_POST['ordina'];
    $from    = $_POST['from'];
    
	$chiave = str_replace("-", " ", $chiave);
	$chiave = addslashes($chiave);
    
    // Lo script termina se il valore di request non è interpretabile.
    if ($request !== "fetch" && $request !== "search") {
        die("Invalid value for parameter 'request'");
    }
    
    // Se non è gia un numero viene convertito in numero.
    // Dopodiché se il numero è negativo lo script termina,
    // se positivo viene ctenuto in considerazione nella query,
    // se nullo, o come stringa conteneva caratteri non validi, 
    // viene ignorato nella query. 
    $raggio = (int)$raggio;
    if ($raggio < 0) {
        die("Invalid value for parameter 'raggio'");
    }
    
    if ($ordina !== "nome" && $ordina !== "distanza") {
        die("Invalid value for parameter 'ordina'");
    }
    
	
    //imposto il giorno per la query
	if ($giorno !== "Lunedi" &&
        $giorno !== "Martedi" &&
        $giorno !== "Mercoledi" &&
        $giorno !== "Giovedi" &&
        $giorno !== "Venerdi" &&
        $giorno !== "Sabato" &&
        $giorno !== "Domenica") {
        die("Invalid value for parameter 'giorno'");
    }
    
    
    $url_non_ristorazione = 'http://www.cartaperdue.it/partner/v2.0/EsercentiNonRistorazione.php';
    $url_ristorazione = 'http://www.cartaperdue.it/partner/v2.0/EsercentiRistorazione.php';
    $post_fields = array(
                         "request" => urlencode($request),
                         "lat"     => urlencode($lat),
                         "long"    => urlencode($long),
                         "chiave"  => urlencode($chiave),
                         "citta"   => urlencode($prov),
                         "giorno"  => urlencode($giorno),
                         "raggio"  => urlencode($raggio),
                         "ordina"  => urlencode($ordina),
                         "from"    => urlencode($from)
                         );
    foreach($post_fields as $key=>$value) { $post_string .= $key.'='.$value.'&'; }
    rtrim($post_string,'&');
    
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url_non_ristorazione);
    curl_setopt($ch, CURLOPT_POST, count($post_fields));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    $json_non_ristorazione = curl_exec($ch);
    curl_close($ch);
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url_ristorazione);
    curl_setopt($ch, CURLOPT_POST, count($post_fields));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    $json_ristorazione = curl_exec($ch);
    curl_close($ch);
    
    /*echo $post_fields."\n";
    foreach($post_fields as $key=>$value) {
        echo $key.'=>'.$value."\n";
    }
    echo 'A: '.$json_non_ristorazione;
    echo 'B: '.$json_ristorazione;*/
    
    $non_rist = json_decode($json_non_ristorazione, TRUE);
    $rist = json_decode($json_ristorazione, TRUE);
    
    if ($from == 0) {
        $non_rist = $non_rist["Esercente:FirstRows"];
        $rist     = $rist["Esercente:FirstRows"];
    } else {
        $non_rist = $non_rist["Esercente:MoreRows"];
        $rist     = $rist["Esercente:MoreRows"];
    }
    
    // Occorre eliminare il [FALSE] finale:
    array_pop($non_rist);
    array_pop($rist);
    
    
    $i = 0;  $j = 0;  $k= 0;
    while ($i < count($non_rist) && $j < count($rist)) { 
        if ($non_rist[$i]["Distanza"] < $rist[$j]["Distanza"]) { 
            $merged[$k] = $non_rist[$i];  
            $i++;
        } else { 
            $merged[$k] = $rist[$j];
            $j++;
        }
        $k++;
    }
    while ($i < count($non_rist)) {
        $merged[$k] = $non_rist[$i];
        $i++;
        $k++;
    }
    while ($j < count($rist)) { 
        $merged[$k] = $rist[$j];
        $j++; 
        $k++;
    }
    
    
    array_push($merged, FALSE);
    
    
    if ($from == 0) {
        echo '{"Esercente:FirstRows":'.json_encode($merged).'}';
    } else {
        echo '{"Esercente:MoreRows":'.json_encode($merged).'}';
    }
    
    ?>


    
