<?php
namespace App\Libraries;

use AndikAryanto11\Datatables;

class DtTables extends Datatables{

    public function __construct($params = [], $retunEntity = true)
    {
        parent::__construct($params,  $retunEntity, false);
    }

    public function setParams()
    {
        $params = array();
        $params['join'] = isset($this->filter['join']) ? $this->filter['join'] : null;
        $params['where'] = isset($this->filter['where']) ? $this->filter['where'] : null;
        $params['whereIn'] = isset($this->filter['whereIn']) ? $this->filter['whereIn'] : null;
        $params['orWhereIn'] = isset($this->filter['orWhereIn']) ? $this->filter['orWhereIn'] : null;
        $params['orWhere'] = isset($this->filter['orWhere']) ? $this->filter['orWhere'] : null;
        $params['whereNotIn'] = isset($this->filter['whereNotIn']) ? $this->filter['whereNotIn'] : null;
        $params['like'] = isset($this->filter['like']) ? $this->filter['like'] : null;
        $params['orLike'] = isset($this->filter['orLike']) ? $this->filter['orLike'] : null;
        $params['limit'] = isset($this->filter['limit']) ? $this->filter['limit'] : null;
        $params['group'] = isset($this->filter['group']) ? $this->filter['group'] : null;

        if(!is_null($this->request->getGet("sortColumn"))){
            $sort = $this->request->getGet("sortColumn");   
            foreach($this->getColumns() as $column){
                $col = explode(".", $column['column']);
                
                if(count($col) == 3){
                    $selectedColumn = $col[1];
                    if($selectedColumn == $sort){
                        $params['order'][$col[0].".".$col[1]] = strtoupper($this->request->getGet("sortOrder"));
                        break;
                    }
                } else {
                    $selectedColumn = $col[0];
                    if($selectedColumn == $sort){
                        $params['order'][$column['column']] = strtoupper($this->request->getGet("sortOrder"));
                        
                        break;
                    }
                }
            }

        }

        if ($this->request->getGet('search')) {
            $searchValue = $this->request->getGet('search');
            $groups = [];
            foreach ($this->getColumns() as $column) {
                if ($column['searchable']) {
                    $col = explode(".", $column['column']);
                    if(count($col) == 3)
                        $groups[$col[0].".".$col[1]] = $searchValue;
                    else if(count($col) == 2)
                        $groups[$col[0].".".$col[1]] = $searchValue;
                    else 
                        $groups[$column['column']] = $searchValue;
                }
            }
            $params['group']['orLike'] = $groups;
        }


        return $params;
    }
}