<?php
namespace App\Eloquents;
use AndikAryanto11\Eloquent;
use CodeIgniter\Config\Services;
use Firebase\JWT\JWT;

class BaseEloquent extends Eloquent{
    
    protected $dbs;
    protected $request;
    public function __construct()
    {
        $this->dbs = \Config\Database::connect();
        $this->request = \Config\Services::request();
        helper('inflector');
        parent::__construct($this->dbs);
    }

    public function parseFromRequest($isJson = false){
        $request = $this->request;
        $fields = $this->dbs->getFieldData($this->table);
        if($isJson)
            $post = $request->getJSON();
        else
            $post = (object)$request->getPost();
        if ($fields) {
            foreach ($fields as $field) {
                $prop = $field->name;
                $type = $field->type;
                $length = $field->max_length;
                
                if (key_exists($prop, $post)){
                    if (!empty($post->$prop)) {
                        if (preg_match("/^int/", $type))
                            $this->$prop = setisnumber($post->$prop);
                        else if (preg_match("/^varchar/", $type))
                            $this->$prop = setisnull($post->$prop);
                        else if (preg_match("/^decimal/", $type))
                            $this->$prop = setisdecimal($post->$prop);
                        else if (preg_match("/^datetime/", $type))
                            $this->$prop = get_formated_date($post->$prop);
                        else if (preg_match("/^date/", $type))
                            $this->$prop = get_formated_date($post->$prop, "Y-m-d");
                        else if (preg_match("/^double/", $type))
                            $this->$prop = $post->$prop;
                        else if(preg_match("/^smallint/", $type)){
                            if($length == 1){
                                $this->$prop = 1;
                            } else {
                                $this->$prop = setisnumber($post->$prop);
                            }
                        }else if (preg_match("/^text/", $type))
                            $this->$prop = $post->$prop;
                    } else {
                        $this->$prop = null;
                    } 
                } else if(preg_match("/^smallint/", $type)){
                    if($length == 1)
                        $this->$prop = null;
                }
            }
        }

        return $this;
    }


    public function beforeSave(){
        $useraccount = null;
        $token = $this->request->getGet('Authorization');
        if(!empty($token)){
            $jwt = JWT::decode($token, getSecretKey(), array('HS256'));
            if($jwt){
                $useraccount = (object)$jwt->User;
                if(empty($this->{static::$primaryKey})){
                    $this->CreatedBy = $useraccount->Username;
                    $this->Created = get_db_date();
                } else {
                    $this->UpdatedBy = $useraccount->Username;
                    $this->Updated = get_db_date();
                }
            }
        }
    }

    private function getClass($class){
        $arr = explode("_",$class);
        return $arr[0]."_".lcfirst(plural($arr[1]));
    }

    private function getForeignKey($key){
        
        $arr = explode("_",$key);
        return $arr[0]."_".ucfirst(singular($arr[1]));
    }

    public function __call($name, $argument)
    {
        if (substr($name, 0, 4) == 'get_' && substr($name, 4, 5) != 'list_' && substr($name, 4, 6) != 'first_') {
            $sufixColumn = isset($argument[0]) ? "_{$argument[0]}" : null;
            $entity = 'App\\Eloquents\\' . $this->getClass(substr($name, 4));
            $field = $this->getForeignKey(substr($name, 4)) . '_Id'. $sufixColumn;
            $entityobject = $entity;
            if (!empty($this->$field)) {
                $result = $entityobject::findOrNew($this->$field);
                return $result;
            } else {
                return new $entityobject;
            }
        } else if (substr($name, 0, 4) == 'get_' && substr($name, 4, 5) == 'list_') {

            $params = isset($argument[0]) ? $argument[0] : null;

            $entity = 'App\\Eloquents\\' .$this->getClass(substr($name, 9));
            $field = str_replace("Entity", "" ,$this->getForeignKey(explode("\\",static::class)[2])) . '_Id';
            $id = !empty($this->{static::$primaryKey}) ? $this->{static::$primaryKey} : null;
            if (!empty($id)) {
                $entityobject = $entity;

                if (isset($params['where'])) {
                    $params['where'][$field] = $id;
                } else {
                    $params['where'] = [
                        $field => $id 
                    ];
                }

                $result = $entityobject::findAll($params);
                return $result;
            }
            return array();
        } else if (substr($name, 0, 4) == 'get_' && substr($name, 4, 6) == 'first_') {

            $params = isset($argument[0]) ? $argument[0] : null;
            $entity = 'App\\Eloquents\\' .$this->getClass(substr($name, 10));
            $field = str_replace("Entity", "" , $this->getForeignKey(explode("\\",static::class)[2])) . '_Id';

            $entityobject = $entity;
            $id = !empty($this->{static::$primaryKey}) ? $this->{static::$primaryKey} : null;
            if (!empty($id)) {

                if (isset($params['where'])) {
                    $params['where'][$field] = $id;
                } else {
                    $params['where'] = [
                        $field => $id
                    ];
                }
                $result = $entityobject::findOneOrNew($params);
                return $result;
            }

            return new $entityobject;
        } else {
            trigger_error('Call to undefined method ' . __CLASS__ . '::' . $name . '()', E_USER_ERROR);
        }
    }
}