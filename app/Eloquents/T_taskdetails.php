<?php  
namespace App\Eloquents;

use App\Classes\Exception\EloquentException;
use App\Eloquents\BaseEloquent;
use App\Libraries\ResponseCode;

class T_taskdetails extends BaseEloquent {

    public $Id;
    public $Name;
    public $Description;
    public $T_Task_Id;
    public $M_User_Id;
    public $Type;
    public $Status;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    protected $table = "t_taskdetails";
    static $primaryKey = "Id";

    public function __construct()
    {   
        parent::__construct();
        // $this->Type = 1;
        // $this->Status = 1;
    }

    public function validate(){
       

        if(empty($this->T_Task_Id))
            throw new EloquentException("Back Log cant be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->M_User_Id))
            throw new EloquentException("Assign to cant be empty", $this, ResponseCode::INVALID_DATA);

    }

    


}