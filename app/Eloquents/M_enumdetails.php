<?php  
namespace App\Eloquents;
use App\Eloquents\BaseEloquent;

class M_enumdetails extends BaseEloquent {

    public $Id;
    public $M_Enum_Id;
    public $Value;
    public $EnumName;
    public $Ordering;
    public $Resource;

    
    protected $table = "m_enumdetails";
    static $primaryKey = "Id";

    public function __construct(){
        parent::__construct();
    }

    public static function findEnumName($enumName, $value){
        $enum = new M_enums();
        $params = [
            'where' => [
                'Name' => $enumName
            ]
        ];

        $enums = $enum->findOne($params)->get_list_M_Enumdetail(['where' => ['Value' => $value]]);
        if($enums){
            if($enums[0]->Resource)
                return lang($enums[0]->Resource);
            else 
                return $enums[0]->EnumName;
        }
        return null;
    }

    public static function findEnums($enumName, $except = array()){

        $enum = new M_enums();
        $params = [
            'where' => [
                'Name' => $enumName
            ]
        ];

        $detailParams = [
            'whereNotIn' => [
                'Value' => $except
            ]
            ];

        $enums = $enum->findOne($params)->get_list_M_Enumdetail($detailParams);
        if($enums){
            foreach($enums as $e){
                if($e->Resource)
                    $e->EnumName = lang($e->Resource);
            }
            return $enums;
        }
        return array();
    }

}