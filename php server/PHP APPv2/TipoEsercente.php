<?php
    
    include '../QueryHelper.php';
    
	$idEsercente=$_POST['idEsercente'];
		
	$qh = new QueryHelper();
    mysql_select_db('cartaperdue');
    	
	
	$query = "SELECT IdTipologia_Esercente, IDcontratto_Contresercente
	FROM attivita_esercente, contratto_esercente
	WHERE 
 	attivita_esercente.IDesercente='$idEsercente'
 	AND contratto_esercente.IDesercente='$idEsercente';";
    
	$json = $qh->query($query);
    
	echo '{"TipologiaEsercente":'.$json.'}';
	?>
