<?php

namespace App\Libraries;

class Session {

    public static function get($name){
        return session()->get($name);
    }

    public static function set($name, $value){
        
        session()->set($name, $value);
    }

    public static function has($name){
        
        return session()->has($name);
    }

    public static function push($name, $newValue){
        
        session()->push($name, $newValue);
    }

    public static function remove($name){
        
        session()->remove($name);
    }

    public static function setFlash($name, $value){
        
        session()->setFlashdata($name, $value);
    }
    public static function getFlash($name){
        
        return session()->getFlashdata($name);
    }

    public static function destroy(){
        
        session()->destroy();
    }

    public static function stop(){
        session()->stop();
    }
}