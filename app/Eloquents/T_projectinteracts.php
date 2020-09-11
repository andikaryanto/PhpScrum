<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class T_projectinteracts extends BaseEloquent {

    public $Id;
    public $M_Project_Id;
    public $M_User_Id;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    protected $table = "t_projectinteracts";
    static $primaryKey = "Id";

    public function __construct()
    {   
        parent::__construct();
    }


}