<?php
namespace App\Controllers\Rests;

use AndikAryanto11\Exception\DatabaseException;
use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\M_positions;
use App\Eloquents\M_profiles;
use App\Eloquents\M_users;
use App\Libraries\DbTrans;
use App\Libraries\ResponseCode;
use Firebase\JWT\JWT;

class Users extends Base_Rest {
    public function __construct()
    {
        parent::__construct();
    }

    

    public function profiles(){
        try{
            if($this->isGranted()){
                $exceptme = $this->request->getGet("exceptme");

                $params = [];
                if($exceptme == "true"){
                    $user = $this->getUseraccount();
                    $params =[
                        "where" => [
                            "Id !=" => $user->Id
                        ]
                    ];
                }
                $user = M_users::findAllOrFail($params);
                $profiles = [];
                foreach($user as $u){
                    $params = [
                        "where" => [
                            "M_User_Id" => $u->Id
                        ]
                    ];
                    $profile = M_profiles::findOne($params);
                    $profile->Name = $u->Name;
                    $profile->Position =$profile->get_M_Position()->Position;
                    $profiles[] = $profile;
                }
                $result = [
                    'Message' => "Success",
                    'Results' => $profiles,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("Failed", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch(DatabaseException $e){

            $user = M_users::findAllOrFail();
            $result = [
                'Message' => "Failed",
                'Results' => null,
                'Status' => ResponseCode::NO_DATA_FOUND
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        } catch(EloquentException $e){
            $result = [
                'Message' => $e->getMessages(),
                'Results' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }

    public function login($username, $password)
    {

        try {

            $query = M_users::login($username, $password);
            if (!$query) {
                throw new EloquentException('User not found', null, ResponseCode::INVALID_LOGIN);
            }

            $sessionexpired = 0; 
            $struserdate = get_current_date("Y-m-d H:i:s");
            $userdate = set_date($struserdate);
            $exipredate = $sessionexpired > 0 ? set_date(date('Y-m-d H:i:s',strtotime("+{$sessionexpired} hours",strtotime($struserdate)))) : null;
           
            $return = [
                "User" => $query,
                "LoggedinAt" => $userdate->getTimestamp(),
                "ExpiredAt" => $exipredate == null? null : $exipredate->getTimestamp()
            ];

            $jwt = JWT::encode($return, getSecretKey());
            $profile = M_profiles::findOneOrNew(["where" => ["M_User_Id" => $query->Id]]);
            $position = $profile->get_M_Position()->Position;
            $result = [
                'Message' => "Login Success",
                'SessionToken' => $jwt,
                'Username' => $query->Name,
                'Photo' => $profile->Photo,
                'Position' => $position,
                'Status' => ResponseCode::OK
            ];
            // $decoded = JWT::decode($jwt, $key, array('HS256')); 
            $this->response->setStatusCode(200)->setJSON($result)->sendBody();
        } catch (EloquentException $e) {
            $result = [
                'Message' => $e->getMessages(),
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }

    public function register(){

        try{
            $user = new M_users;
            $user->parseFromRequest(true);
            $user->setPassword($user->Password);

            DbTrans::beginTransaction();
            if($user->save()){

                $profile = new M_profiles();
                $profile->M_User_Id = $user->Id;
                $profile->save();

                $result = [
                    'Message' => "Register Success",
                    'Result' => null,
                    'Status' => ResponseCode::OK
                ];
                DbTrans::commit();
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("Failed to register", null, ResponseCode::FAILED_SAVE_DATA);
                
            }
        } catch(EloquentException $e) {

            DbTrans::rollback();
            $result = [
                'Message' => $e->getMessages(),
                'Result' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
                
        
    }

    public function updateProfile($userid){

    }

    public function updateToken($userid){
        try{
            $user = M_users::find($userid);
            if(!empty($user)){
                $token = $this->request->getJson()->Token;
                $user->FirebaseToken = $token;
                $user->save();
                $result = [
                    'Message' => "Success",
                    'Result' => null,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("Failed to save", null, ResponseCode::FAILED_SAVE_DATA);
            }

        } catch(EloquentException $e){
            $result = [
                'Message' => $e->getMessages(),
                'Result' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }

    public function profile(){

        if($this->isGranted()){
            $user = $this->getUseraccount();
            $params = [
                "where" => [
                    "M_User_Id" => $user->Id
                ]
            ];
            $profile = M_profiles::findOneOrNew($params);
            $profile->Position = $profile->get_M_Position();
            $result = [
                'Message' => "Success",
                'Result' => $profile,
                'Status' => ResponseCode::OK
            ];
            $this->response->setStatusCode(200)->setJSON($result)->sendBody();
        } else {
            $result = [
                'Message' => "Failed",
                'Result' => null,
                'Status' => ResponseCode::OK
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }
}