<?php  
namespace App\Eloquents;

use App\Classes\Exception\EloquentException;
use App\Eloquents\BaseEloquent;
use App\Libraries\ResponseCode;

class T_comments extends BaseEloquent {

    public $Id;
    public $M_User_Id;
    public $T_Taskdetail_Id;
    public $Comment;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    
    protected $table = "t_comments";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

    public function validate(){
      
        if(empty($this->M_User_Id))
            throw new EloquentException("Please Login", $this, ResponseCode::INVALID_DATA);

        if(empty($this->T_Taskdetail_Id))
            throw new EloquentException("Story Not Found", $this, ResponseCode::INVALID_DATA);

        if(empty($this->Comment))
            throw new EloquentException("Comment cant be empty", $this, ResponseCode::INVALID_DATA);

    }

}