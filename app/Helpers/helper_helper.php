<?php

function encryptMd5($string){
    $hash = md5($string);
    $lastestString = substr($hash, strlen($hash) - 5, 5);
    $newChar = strrev($lastestString);
    $newString = substr($hash, 0,strlen($hash) - 5).$newChar;
    return $newString;
}

function get_variable(){
    return appKey_config();
}

function setisnull($data){
    if(empty($data))
        return null;
    else 
        return $data;
}



function setisdecimal($data){
    if(empty($data))
        return 0.00;
    else {
        $data = str_replace(".","", $data);
        $newvalue = str_replace(",",".", $data);
        return $newvalue;
    }
}

function setisnumber($data, $default = 0){
    if(empty($data))
        return $default;
    else 
        return $data;
}

function deleteStatus($msg = NULL, $status = TRUE, $isforbidden = FALSE){
    $delete['msg'] = $msg;
    $delete['status'] = $status;
    $delete['isforbidden'] = $isforbidden;
    return $delete;
}

function getDeleteMessage(){
    $msg = array();

    $msg = array_merge($msg, array(0=>lang('Form.datadeleted')));
    return $msg;
}

function getDeleteErrorMessage(){
    $msg = array();

    $msg = array_merge($msg, array(0=>lang('Info.error_occur_while_try_delete_data')));
    return $msg;
}

function getQueryErrorMessage($code){
    $msg = array();

    if($code == $this->queryErrorCode()['datainrefenrence']){
        $msg = array_merge($msg, array(0=>lang('ui_datainreference')));
    }

    return $msg;
}

function getSecretKey(){
    return "5e3a52352b587";
}

function randomnumber($digits = 4){
    return rand(pow(10, $digits-1), pow(10, $digits)-1);
}

