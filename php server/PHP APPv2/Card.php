<?php
    
    include 'QueryHelper.php';
    
    
	$name       = $_POST['name'];
    $surname    = $_POST['surname'];
    $number     = $_POST['number'];
    $expiration = $_POST['expiration'];
    
    $qh = new QueryHelper();
    
    $query = "SELECT Nome_Utente AS name, Cognome_Utente AS surname, Codice_Contrcarta_Utente AS number, Data_scadenza_Contrcarta_Utente AS expiryString FROM cartaperdue.UTENTI_ACCESS WHERE REPLACE(Nome_Utente, ' ', '') = REPLACE('$name', ' ','') AND REPLACE(Cognome_Utente, ' ', '') = REPLACE('$surname', ' ', '') AND REPLACE(Codice_Contrcarta_Utente, ' ', '') = REPLACE('$number', ' ', '')";
    
        
    $json_result = $qh->query($query);
    
    
    echo '{"Card":'.$json_result.'}';
    
?>