<?php

    include 'utils.inc';
    include 'QueryHelper.php';
    
    
	$usr = $_POST['usr'];
    $psw = $_POST['psw'];
    
    $qh = new QueryHelper();
    
    $query = "SELECT idcustomer, nome_contatto,cognome_contatto FROM cartaperdue.tcustomer WHERE usr = '$usr' AND pwd = '$psw' ";
    
    $json_result = $qh->query($query);
    
    
    echo '{"login":'.$json_result.'}';
    
?>