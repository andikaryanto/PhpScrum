<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class T_commentattachments extends BaseEloquent {

    public $Id;
    public $T_Comment_Id;
    public $FileName;
    public $Type;
    public $UrlFile;
    public $Created;
    public $CreatedBy;
    public $Updated;
    public $UpdatedBy;

    
    protected $table = "t_commentattachments";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

}