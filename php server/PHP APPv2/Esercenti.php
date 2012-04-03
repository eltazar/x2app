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
    } else if ($categ !== "") { 
        die ("Invalid value for parameter 'categ'");
    }
