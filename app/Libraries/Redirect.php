<?php

namespace App\Libraries;

class Redirect {

    private $route;
    private $code = 303;
    private function __constrcut(){
        
    }

    public function setStatusCode(int $code){
        $this->code = $code;
        return $this;
    }

    public static function redirect($route){
        $redirect = new static;
        $redirect->route = $route;
        return $redirect;
    }

    public function with($data){
        Session::set('data', get_object_vars($data));
        return $this;
    }

    public function go(){
        return redirect()->route($this->route, [], $this->code);
    }
}