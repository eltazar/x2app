<?php

    include 'QueryHelper.php';

    $request     = $_POST['request'];
    $card_number = $_POST['card_number'];
    $device_udid = $_POST['device_udid'];

    $qh = new QueryHelper();

    if (!strcmp($request, 'Check')) {
        $query = "SELECT udid_iphone FROM cartaperdue_app.abbinamento_carta_iphone WHERE codice_carta = REPLACE('$card_number', ' ', '')";

        $json_results = $qh->query($query);
        if (!$json_results) {
            $response = "Associated:Error";
        } else {
            $results_array = json_decode($json_results);
            $fetched_udid = $results_array[0]->udid_iphone;
            
            if (!strcmp($device_udid, $fetched_udid)) {
                $response = "Associated:This";
            } else if (!strcmp('', $fetched_udid)) {
                $response = "Associated:No";
            } else {
                $response = "Associated:Another";
            }
        }

        echo '{"CardDeviceAssociation:Check": '.json_encode($response).'}';
    }
    //ATTENZIONE QUESTA VERSIONE DELLO SCRIPT è VECCHIA RISPETTO A QUELLA SUL SERVER!!!
    if (!strcmp($request, 'Set')) {
        $query = "INSERT INTO cartaperdue_app.abbinamento_carta_iphone (codice_carta, udid_iphone) VALUES (REPLACE('$card_number', ' ', ''), '$device_udid') ON DUPLICATE KEY UPDATE udid_iphone='$device_udid'";
        
        $result = $qh->raw_query($query);
        if (!$result) {
            $response = "Fail";
        } else {
            $response = "Success";
        }
        
        $query = "INSERT INTO cartaperdue_app.abbinamento_carta_iphone (codice_carta, udid_iphone) VALUES (REPLACE('$card_number', ' ', ''), '$device_udid') ON DUPLICATE KEY UPDATE udid_iphone='$device_udid'";
        $result2 = $qh->raw_query($query);
        if (!$result2) {
            $response2 = "Fail";
        } else {
            $response2 = "Success";
        }
        
        echo '{"CardDeviceAssociation:Set": '.json_encode($response).'}';
    }

?>

