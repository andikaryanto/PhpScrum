<?php

namespace App\Controllers\Rests;
// header('Access-Control-Allow-Origin: *');
// header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
// header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');

use App\Libraries\ResponseCode;
use \Firebase\JWT\JWT;
use Core\Rest\Response;
use yidas\http\Request;
use App\Controllers\BaseController;

class Base_Rest extends BaseController
{

    private $useraccount = null;

    public function __construct()
    {
        
    }

    public function isGranted()
    {

        $token = $this->request->getGet('Authorization');
        $jwt = JWT::decode($token, getSecretKey(), array('HS256'));
        if($jwt){
            $this->useraccount = (object)$jwt->User;
            $currenttime =  set_date(get_current_date("Y-m-d H:i:s"));
            if($currenttime->getTimestamp() > $jwt->ExpiredAt && $jwt->ExpiredAt != null){
                $result = [
                    'Message' => "Sesi Anda Telah Habis",
                    'Result' => null,
                    'Status' => ResponseCode::SESSION_EXPIRED
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
                exit;
            }
        }
        return true;
    }

    public function getUseraccount(){
        $token = $this->request->getGet('Authorization');
        $jwt = JWT::decode($token, getSecretKey(), array('HS256'));
        if($jwt){
            $this->useraccount = (object)$jwt->User;
            return $this->useraccount;
        }
        return null;
    }

    
}
