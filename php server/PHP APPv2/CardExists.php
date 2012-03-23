<?php
    
    include 'QueryHelper.php';
    
    
	$name       = $_POST['name'];
    $surname    = $_POST['surname'];
    $number     = $_POST['number'];
    $expiration = $_POST['expiration'];
    
    $qh = new QueryHelper();
    
    $query = "SELECT Id_Utente FROM cartaperdue.UTENTI_ACCESS WHERE Nome_Utente = '$name' AND Cognome_Utente = '$surname' AND Codice_Contrcarta_Utente = '$number' ";
    
        
    $json_result = $qh->query($query);
    
    
    echo '{"response":'.$json_result.'}';
    
?>