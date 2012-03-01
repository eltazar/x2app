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

	
	$sql="INSERT INTO coupon_transazioni_iphone SET numero_carta_credito='$num', email='peppelisanti85@gmail.com' ";

	
	$rs = mysql_query($sql) or die(mysql_error());
		
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {
		$arr[] = $obj;
	}
	
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	?>