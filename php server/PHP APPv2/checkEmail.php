<?php

    include 'utils.inc';
    
	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue_app';
    
    
	$usr = $_POST['usr'];
    
    $sql = "SELECT idcustomer, nome_contatto,cognome_contatto FROM cartaperdue.tcustomer WHERE usr = '$usr'";
    
    
    //echo $sql;
    
    
    
    $connessione = mysql_connect($host,$uid,$pwd) or die("Connessione al db non riuscita: " . mysql_error());
    //print ("Connesso con successo");
    
    mysql_select_db ( $db, $connessione ) or die("Errore selezione db: " . mysql_error());;
    $query = mysql_query($sql) or die("query non riuscita: " . mysql_error());;
    
    mysql_close($connessione);

    
    $i=0;
    while(($a[$i] = mysql_fetch_object($query)) && ($i < 125)){
        
        $i++;
    }
    
    echo '{"checkEmail":'.json_encode($a).'}';
    
?>