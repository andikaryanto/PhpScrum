<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class M_positions extends BaseEloquent {

    public $Id;
    public $Position;
    public $Description;

    
    protected $table = "m_positions";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

}