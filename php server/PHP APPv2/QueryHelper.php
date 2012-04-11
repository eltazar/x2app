<?php
    
    class QueryHelper
    {
        private static $host = 'sql.cartaperdue.it.cloud.seeweb.it'; 
        private static $usr= 'appperdue'; 
        private static $pwd = 'Pitagora2011';
        private static $appDb = 'cartaperdue_app';
        private $sql_connection;
        
        public function __construct() {
            $this->sql_connection = mysql_connect(self::$host, self::$usr, self::$pwd);
            if ($this->sql_connection){
                mysql_select_db(self::$appDb, $this->sql_connection);
                $this->raw_query("SET NAMES 'utf8'");
            }
        }
        
        public function query($query) {
            $results = $this->raw_query($query);
            if ($results == FALSE) {
                return json_encode("ERROR");
            } else {
                while($resultsArray[] = mysql_fetch_object($results)) {  }
                return json_encode($resultsArray);
            }
            //$results = mysql_query($query, $this->sql_connection);
            //if ($results) {
            //    while($resultsArray[] = mysql_fetch_object($results)) {  }
            //    return json_encode($resultsArray);
            //} else {
            //    return "('Error')";
            //}
        }
        
        public function raw_query($query) {
            return mysql_query($query, $this->sql_connection);
        }
        
        public function lastInsertedRowId() {
            return mysql_insert_id($this->sql_connection);
        }
        
        public function lastError() {
            return mysql_error($this->sql_connection);
        }
        
        public function __destruct() {
            mysql_close($this->sql_connection);
        }
        
        
        
    }
?>
