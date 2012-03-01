<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Carta PerDue</title>
	<head>
	<body>
	<center>
		<h1>Transazioni da confermare</h1>
	</center>
	<?php
		include "utils.inc";
	
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
	
		$sql="SELECT * FROM coupon_transazioni_iphone ";
	
		
		$rs = mysql_query($sql) or die(mysql_error());
			
		// Add the rows to the array 
		while($obj = mysql_fetch_object($rs)) {
			
			print "Nome: ".$obj->nome." ".$obj->cognome."<br/>";
			print "email: ".$obj->email."<br/>";
			//print "Numero Carta di Credito: ".valueBackward($obj->numero_carta_credito);
			print "<br/><br/>------------------------- <br/><br/>";
		}
	?>
	</body>
</html>