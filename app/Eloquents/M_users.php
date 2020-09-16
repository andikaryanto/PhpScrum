<?php
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class M_users extends BaseEloquent {
    public $Id;
    public $Email;
    public $Name;
    public $Username;
    public $Password;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    protected $table = "m_users";
    static $primaryKey = "Id";

    public function __construct()
    {   
        parent::__construct();
    }

    public function setPassword($password){
        $this->Password = encryptMd5(get_variable().$this->Username.$password);
        return $this->Password;
    }

    public static function login($username, $password){

        $params = array(
            'where' => array(
                'password' => encryptMd5(get_variable() . $username . $password)
            )
        );
        // print_r($user);
        $query = static::findOne($params);
        return $query;
    }

   

}