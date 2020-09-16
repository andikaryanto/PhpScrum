<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class M_enums extends BaseEloquent {

    public $Id;
    public $Name;

    
    protected $table = "m_enums";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

}