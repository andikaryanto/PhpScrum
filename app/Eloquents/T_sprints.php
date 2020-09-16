<?php  
namespace App\Eloquents;

use App\Classes\Exception\EloquentException;
use App\Eloquents\BaseEloquent;
use App\Libraries\ResponseCode;

class T_sprints extends BaseEloquent {

    public $Id;
    public $M_Project_Id;
    public $Name;
    public $Description;
    public $DateStart;
    public $DateEnd;
    public $IsActive;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    protected $table = "t_sprints";
    static $primaryKey = "Id";

    public function __construct()
    {   
        parent::__construct();
    }

    public function validate(){
        $p = [
            "Name" => $this->Name,
            "M_Project_Id" => $this->M_Project_Id
        ];

        if($this->isDataExist($p)){
            throw new EloquentException("Name Exist", $this, ResponseCode::DATA_EXIST);
        }

        if(empty($this->Name))
            throw new EloquentException("Name can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->M_Project_Id))
            throw new EloquentException("Project can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->DateStart))
            throw new EloquentException("Start Date can be empty", $this, ResponseCode::INVALID_DATA);

        if(empty($this->DateEnd))
            throw new EloquentException("End Date can be empty", $this, ResponseCode::INVALID_DATA);

    }


}