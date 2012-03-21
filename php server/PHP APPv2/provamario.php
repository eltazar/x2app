<?php

    include 'utils.inc';
    
	// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue_app';
    
	$idCoupon=$_POST["identificativo"];
	$idiphone=$_POST['idiphone'];
	$valore=$_POST["valore"];
	$quantita=$_POST['quantita'];
	$importo=$_POST['importo'];

	$idUtente = $_POST['idUtente'];
    
	$email=$_POST['email'];
	$email = addslashes($email);
	
	$telefono=$_POST['telefono'];
	$tipocarta=$_POST['tipocarta'];
	$numerocarta=$_POST['numerocarta'];
	$mesescadenza=$_POST['mesescadenza'];
	$annoscadenza=$_POST['annoscadenza'];
	$intestatario=$_POST['intestatario'];
	$intestatario = addslashes($intestatario);
	
	$statopagamento="richiesto";
	$cvv=$_POST['cvv'];
	
    /*
    echo "MARIO SERVER:\n".
        "IDUTENTE = ".$idUtente."\n".
        "IDENTIFICATIVO= ". $idCoupon."\n".
        "IDIPHONE= ".$idiphone."\n".
        "QUANTITA= ".$quantita."\n".
        "VALORE = ".$valore."\n".
        "IMPORTO= ".$importo."\n".
        "TIPOCARTA= ".$tipocarta."\n".
        "NUMERO CARTA= ".$numerocarta."\n".
        "MESE= ".$mesescadenza."\n".
        "ANNO= ".$annoscadenza."\n".
        "INTESTATARIO= ".$intestatario."\n".
        "CVV= ".$cvv."\n"; 
   */  
    
    
    /*
    $primaparte=substr($numerocarta, 0, 8);
	$secondaparte=substr($numerocarta,8);
    
    $destinatario = "mrgreco3@gmail.com";
	$oggetto = "Richiesta acquisto numero ".$id." - Prima Parte";
	$messaggio = "Identificativo offerta: $identificativo\n\nRichiesta acquisto da parte di: $nome $cognome\nEmail: $email\nTelefono: $telefono\n Valore Coupon: $valore\nQuantità: $quantita\nImporto Totale: $importo\n Tipo Carta: $tipocarta\n Intestatario Carta: $intestatario\n Scadenza Carta: $mesescadenza/$annoscadenza\n CVV: $cvv\nPrima parte: $primaparte";
	//$mittente = 'From: "AppPerDue"'; 
	
    $mittente = 'From: "PerDue"';
    
    mail($destinatario, $oggetto, $messaggio,$mittente) or die("MAIL NON INVIATA");
	
	$destinatario = "el-tazar@hotmail.it";
	$oggetto = "Richiesta acquisto numero ".$id." - Seconda Parte";
	$messaggio = "Identificativo offerta: $identificativo\n\nRichiesta acquisto da parte di: $nome $cognome\nEmail: $email\nTelefono: $telefono\n Valore Coupon: $valore\nQuantità: $quantita\nImporto Totale: $importo\n Tipo Carta: $tipocarta\n Intestatario Carta: $intestatario\n Scadenza Carta: $mesescadenza/$annoscadenza\n CVV: $cvv\nSeconda parte: $secondaparte";
	mail($destinatario, $oggetto, $messaggio,$mittente);
    
    
    //email al cliente
    $destinatario = "marius0610@hotmail.it";
	$oggetto = "Richiesta acquisto inoltrata";
	$messaggio = "HAI ACQUISTATO IL COUPON bla bla bla";
	mail($email, $oggetto, $messaggio,$mittente);

    
    */
	
    
    //recupero la descrizione del coupon
    $connessione = mysql_connect($host, $uid, $pwd) or die("Could not connect");
    
    //select database
	mysql_select_db("cartaperdue_coupon") or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	// Create an array to hold our results
	$arr = array();
    
	$sql1="SELECT offerta_titolo_breve
    FROM coupon_tofferte
    WHERE idofferta='$idCoupon' ";
	
    $rs1 = mysql_query($sql1) or die(mysql_error());
	while ($riga = mysql_fetch_object($rs1)) {
    	$titolo=$riga->offerta_titolo_breve;
    }
    
    mysql_close($connessione);
    
    
    //salvo sul db dell'app la richiesta di acquisto coupon
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
    mysql_select_db("cartaperdue_app") or die("database relativo all'app nn selezioanbile");
    
	$sql="INSERT INTO app_tcoupon_acquistati SET id_coupon='$idCoupon', id_customer = '$idUtente', data_acquisto=now(),quantita = '$quantita', valore = '$valore', importo_totale ='$importo', udid = '$idiphone', stato = '$statopagamento' ";
    
    //echo $sql;

	$rs = mysql_query($sql) or die("ERRORE query acquisto coupon: ".mysql_error());
    
     
    //$id è l'id del record della transazione salvata!! 
	$id=mysql_insert_id(); 
	
    mysql_close($link);
    
    
    
    //recupero i dati anagrafici dell'acquirente
    
    $nome = "";
    $cognome = "";
    $email="";
    $cellulare = "";
    $telefono = "";
    
    
    $connessione2 = mysql_connect($host, $uid, $pwd) or die("Could not connect");
    
    //select database
	mysql_select_db("cartaperdue") or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	// Create an array to hold our results
	$arr = array();
    
	$sql2="SELECT usr,nome_contatto,cognome_contatto,cellulare,telefono FROM tcustomer WHERE idcustomer = '$idUtente'";
	
    $rs2 = mysql_query($sql2) or die("QUERT recupero dati utente fallita: ".mysql_error());
	while ($riga = mysql_fetch_object($rs2)) {
    	$nome = $riga->nome_contatto;
        $cognome = $riga->cognome_contatto;
        $email = $riga->usr;
        $telefono = $riga->telefono;
        $cellulare = $riga->cellulare;
    }
    
    mysql_close($connessione2);
    
    //echo "DATI UTENTE = ".$nome." ".$cognome." ".$email." ".$telefono." ".$cellulare;
    
    
    
    
    
    
	$primaparte=substr($numerocarta, 0, 8);
	$secondaparte=substr($numerocarta,8);
	$destinatario = "mrgreco3@gmail.com";
    
	//$destinatario = "m.parroco@cartaperdue.it";
	$oggetto = "Richiesta acquisto numero $id - Prima Parte";
	$messaggio = "Offerta: $titolo\nIdentificativo offerta: $idCoupon\n\nRichiesta acquisto da parte di: $nome $cognome\nEmail: $email\nTelefono: $telefono\nCellulare: $cellulare\nValore Coupon: $valore\nQuantità: $quantita\nImporto Totale: $importo\n Tipo Carta: $tipocarta\n Intestatario Carta: $intestatario\n Scadenza Carta: $mesescadenza/$annoscadenza\n CVV: $cvv\nPrima parte: $primaparte";
	$mittente = 'From: "AppPerDue"'; 
	mail($destinatario, $oggetto, $messaggio,$mittente);
	
    $destinatario = "el-tazar@hotmail.it";
	//$destinatario = "segreteria@cartaperdue.it";
	$oggetto = "Richiesta acquisto numero $id - Seconda Parte";
	$messaggio = "Offerta: $titolo\nIdentificativo offerta: $idCoupon\n\nRichiesta acquisto da parte di: $nome $cognome\nEmail: $email\nTelefono: $telefono\nCellulare: $cellulare\n Valore Coupon: $valore\nQuantità: $quantita\nImporto Totale: $importo\n Tipo Carta: $tipocarta\n Intestatario Carta: $intestatario\n Scadenza Carta: $mesescadenza/$annoscadenza\n CVV: $cvv\nSeconda parte: $secondaparte";
	mail($destinatario, $oggetto, $messaggio,$mittente);
    
	
    //email al cliente
    $destinatario = "marius0610@hotmail.it";
	$oggetto = "Richiesta acquisto coupon inviata";
	$messaggio = "HAI ACQUISTATO IL COUPON bla bla bla";
	mail($destinatario, $oggetto, $messaggio,$mittente);
    
    //return the json result. The string users is just a name for the container object. Can be set anything.
	echo "Ok";

    
?>