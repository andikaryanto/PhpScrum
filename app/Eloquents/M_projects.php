<?php  
namespace App\Eloquents;

use App\Classes\Exception\EloquentException;
use App\Eloquents\BaseEloquent;
use App\Libraries\ResponseCode;

class M_projects extends BaseEloquent {

    public $Id;
    public $Name;
    public $Description;
    public $StartDate;
    public $EndDate;
    public $Status;
    public $M_User_Id;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    protected $table = "m_projects";
    static $primaryKey = "Id";

    public function __construct()
    {   
        parent::__construct();
    }

    public function validate(){
        $p = [
            "Name" => $this->Name
        ];

        if($this->isDataExist($p)){
            throw new EloquentException("Name Exist", $this, ResponseCode::DATA_EXIST);
        }

        if(empty($this->Name))
            throw new EloquentException("Name can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->StartDate))
            throw new EloquentException("Start Date can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->EndDate))
            throw new EloquentException("End Date can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->Description))
            throw new EloquentException("Description can be empty", $this, ResponseCode::INVALID_DATA);
        
        
        if(empty($this->M_User_Id))
            throw new EloquentException("You are not logged in", $this, ResponseCode::INVALID_DATA);
    }


}