<?php
		// Database credentials
	$host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
	$uid = 'appperdue'; 
	$pwd = 'Pitagora2011';
	$db = 'blogcartaperduenew';
	$identificativo=$_GET['id'];
	$from=$_GET['from']; 
	$to=$_GET['to'];
	
	$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");
	
	//select database
	mysql_select_db($db) or die("Could not select database");
	mysql_query("SET NAMES 'utf8' ");
	// Create an array to hold our results
	$arr = array();
	
	$sql="SELECT comment_author, comment_content, comment_date, comment_ID
	FROM wp_comments,wp_posts
	WHERE comment_post_ID=ID
	AND idesercente='$identificativo'
	AND comment_approved='1'
	ORDER BY comment_date DESC
	LIMIT $from,$to;";


	
	$rs = mysql_query($sql) or die(mysql_error());
	// Add the rows to the array 
	while($obj = mysql_fetch_object($rs)) {	
		$arr[] = $obj;
		
	}
	
		//return the json result. The string users is just a name for the container object. Can be set anything.
	echo '{"Esercente":'.json_encode($arr).'}';
	?>