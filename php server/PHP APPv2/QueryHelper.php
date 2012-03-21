<?php
    
    class QueryHelper
    {
        private static $host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
        private static = 'appperdue'; 
        private static $pwd = 'Pitagora2011';
        private static $appDb = 'cartaperdue_app';
        private $sql_connection;
        
        public function __construct() {
            $this->$sql_connection = mysql_connect($host, $usr, $pwd);
            if ($this->$sql_connection){
                mysql_select_db($this->appDb, $this->appDb);
            }
        }
        
        public function query($query) {
            $results = mysql_query($query)
            if ($results) {
                while($object = mysql_fetch_object($results)) {
                    $resultsArray[] = $object;
                }
                return json_encode($resultsArray);
            }
            else {
                return mysql_error();
            }
        }

        public function __destruct() {
            mysql_close($self->sql_connection)
        }
                               
                               
        
    }
?>

/* Database credentials

$db2 = 'cartaperdue';

$citta=$_GET['prov'];
$citta=str_replace("!"," ",$citta); //nel client lo spazio è stato sostituito da un carattere speciale. Qui ricostruingo la stringa

$link = mysql_connect($host, $uid, $pwd) or die("Could not connect");

//select database
mysql_select_db($db) or die("Could not select database");
mysql_select_db($db2) or die("Could not select database");

mysql_query("SET NAMES 'utf8' ");
// Create an array to hold our results
$arr = array();

$sql="SELECT coupon_tofferte.idofferta,offerta_titolo_breve,idesercente, offerta_foto_big,coupon_valore_acquisto, coupon_valore_facciale
FROM cartaperdue_coupon.coupon_tofferte,cartaperdue_coupon.tofferte_province ,cartaperdue.wrp_province
WHERE
tofferte_province.idofferta=coupon_tofferte.idofferta
AND wrp_province.provincia='$citta'
AND tofferte_province.idprovincia=wrp_province.idprovincia 
AND DATEDIFF(offerta_periodo_al,NOW())>='0'
AND DATEDIFF(NOW(),offerta_periodo_dal)>='0'

AND offerta_attiva='1'
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
*/