<?php
    
    include 'QueryHelper.php';
    
    
	$name       = $_POST['name'];
    $surname    = $_POST['surname'];
    $number     = $_POST['number'];
    $expiration = $_POST['expiration'];
    
    $qh = new QueryHelper();
    
    $query = "SELECT Nome_Utente AS name, Cognome_Utente AS surname, Codice_Contrcarta_Utente AS number, DATE_FORMAT(Data_scadenza_Contrcarta_Utente, '%d/%m/%Y') AS expiryString FROM cartaperdue.UTENTI_ACCESS WHERE REPLACE(Nome_Utente, ' ', '') = REPLACE('$name', ' ','') AND REPLACE(Cognome_Utente, ' ', '') = REPLACE('$surname', ' ', '') AND REPLACE(Codice_Contrcarta_Utente, ' ', '') = REPLACE('$number', ' ', '')";
    
        
    $json_result = $qh->query($query);
    $results = json_decode($json_result, TRUE);
    
    if (count($results) >= 2) {
        echo '{"Card":'.$json_result.'}';
    } else {
        $query = "SELECT tcustomer.nome_contatto AS name, tcustomer.cognome_contatto AS surname, tacquisti_carte_online.codice_carta AS number, DATE_FORMAT(tacquisti_carte_online.data_scadenza, '%d/%m/%Y') AS expiryString FROM cartaperdue.tcustomer, cartaperdue_app.tacquisti_carte_online WHERE tcustomer.idcustomer = tacquisti_carte_online.id_utente AND REPLACE(nome_contatto, ' ', '') = REPLACE('$name', ' ','') AND REPLACE(cognome_contatto, ' ', '') = REPLACE('$surname', ' ', '') AND REPLACE(codice_carta, ' ', '') = REPLACE('$number', ' ', '')";
        $json_result = $qh->query($query);
        echo '{"Card":'.$json_result.'}';
    }
    
    
?>