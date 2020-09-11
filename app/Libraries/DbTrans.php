<?php
namespace App\Libraries;

class DbTrans {

    private static $instance = false;
    private $db;

    private function __construct(){
        $this->db = \Config\Database::connect();
    }

    private static function getInstance(){
        if(!self::$instance)
            self::$instance = new self;
        return self::$instance;
    }

    public static function beginTransaction(){
        $instance = self::getInstance();
        $instance->db->transStart();
    }

    public static function commit(){
        
        $instance = self::getInstance();
        $instance->db->transComplete();
    }

    public static function rollback(){
        
        $instance = self::getInstance();
        $instance->db->transRollback();
    }
}