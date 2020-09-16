<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class M_profiles extends BaseEloquent {

    public $Id;
    public $M_User_Id;
    public $M_Position_Id;
    public $About;
    public $Photo;

    
    protected $table = "m_profiles";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

}