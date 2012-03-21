<?php
    include 'QueryHelper.php'

    $card_number = $_POST['card_number'];
    $device_udid = $_POST['device_udid'];

    $qh = new QueryHelper();

    $query = 'SELECT udid_iphone FROM cartaperdue_app.abbinamento_carta_iphone WHERE codice_carta ='.$card_number;

    $json_result = $qh->query($query);
    $fetched_udid = json_decode($json_result);

    if ($device_udid==$fetched_udid){
        $response = TRUE;
    } else {
        $responde = FALSE;
    }

    echo json_encode($response);
?>

