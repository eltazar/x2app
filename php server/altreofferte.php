<?php
		// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'cartaperdue_coupon';
	
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	// Create an array to hold our results
	$arr = array();
	
	$sql="SELECT idofferta,offerta_titolo_breve,idesercente, offerta_foto_vetrina,coupon_valore_acquisto, coupon_valore_facciale
	FROM coupon_tofferte
	WHERE 
	DATEDIFF(offerta_periodo_al,NOW())>='0'
	AND offerta_attiva='1'
	AND posizione <> '1'
	ORDER BY posizione
		;";

	
	$rs = mysql_query($sql) or die(mysql_error());
		
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	?>