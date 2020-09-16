<?php

function get_current_date($format = null){
    $date = new DateTime('now', new DateTimeZone('Asia/Jakarta'));
    if(isset($format))
        return $date->format($format);
    return $date->format('d-m-Y');
    
}

function get_db_date(){
    
    $dbs = \Config\Database::connect();
    $data = $dbs->query('SELECT NOW() as now')->getRowObject(0);
    return $data->now;
}

function set_date($strdate = null){
    if(!empty($strdate))
        $date = new DateTime($strdate, new DateTimeZone('Asia/Jakarta'));
    else 
        $date = new DateTime('now', new DateTimeZone('Asia/Jakarta'));
    return $date;
}

function get_date($strdate, $add = '', $format = "Y-m-d H:i:s"){

    $date = date_create($strdate);
    if($add)
        date_add($date,date_interval_create_from_date_string($add));
    return date_format($date, $format);
}



function get_formated_date($strdate = null, $format = null){

    if($strdate)
        $date = new DateTime($strdate, new DateTimeZone('Asia/Jakarta'));
    else 
        $date = new DateTime('now', new DateTimeZone('Asia/Jakarta'));
    if(isset($format))
        return $date->format($format);
    return $date->format('Y-m-d H:i:s');
}