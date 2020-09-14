<?php
namespace App\Controllers\Rests;

use AndikAryanto11\Exception\DatabaseException;
use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\M_projects;
use App\Eloquents\T_projectinteracts;
use App\Eloquents\T_sprints;
use App\Eloquents\T_taskdetails;
use App\Eloquents\T_tasks;
use App\Libraries\DbTrans;
use App\Libraries\ResponseCode;
use Firebase\JWT\JWT;

class Sprints extends Base_Rest {
    public function __construct()
    {
        parent::__construct();
    }

    public function createSprint(){
        
        try{
            DbTrans::beginTransaction();
            if($this->isGranted()){
                $task = new T_sprints();
                $task->parseFromRequest(true);
                $task->IsActive = 1;
                $task->validate();
                if($task->save()){
                    $result = [
                        'Message' => "Success",
                        'Result' => $task,
                        'Status' => ResponseCode::OK
                    ];
                    $this->response->setStatusCode(200)->setJSON($result)->sendBody();
                } else {
                    throw new EloquentException("Failed to save data", $task, ResponseCode::FAILED_SAVE_DATA);
                }
            } else {
                throw new EloquentException("Not Granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch (EloquentException $e){
            $result = [
                'Message' => $e->getMessage(),
                'Result' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }
}