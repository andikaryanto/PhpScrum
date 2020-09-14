<?php
namespace App\Controllers\Rests;

use AndikAryanto11\Exception\DatabaseException;
use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\M_projects;
use App\Eloquents\T_projectinteracts;
use App\Eloquents\T_taskdetails;
use App\Eloquents\T_tasks;
use App\Libraries\DbTrans;
use App\Libraries\ResponseCode;
use Firebase\JWT\JWT;

class Tasks extends Base_Rest {
    public function __construct()
    {
        parent::__construct();
    }

    public function createBacklog(){
        try{
            if($this->isGranted()){
                $task = new T_tasks();
                $task->parseFromRequest(true);
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

    public function getTask($id){
        try{
            if($this->isGranted()){
                $task = T_tasks::find($id);
                $task->Taskdetails = $task->get_list_T_taskdetail(['order' => ['M_User_Id' => "ASC"]]);
                foreach($task->Taskdetails as $detail){
                    $detail->AssignTo = $detail->get_M_User()->Name;
                }

                $result = [
                    'Message' => "Success",
                    'Result' => $task,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
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

    public function deleteBatchTask(){
        DbTrans::beginTransaction();
        try{
            if($this->isGranted()){
                
                $deleteId = (array)$this->request->getJSON()->TaskIds;
                foreach($deleteId as $id){
                    $task = T_taskdetails::find($id);
                    if(!$task->delete()){
                        throw new EloquentException("Cant delete one or more items", null, ResponseCode::NO_ACCESS_USER_MODULE);
                    }
                }
                DbTrans::commit();
                $result = [
                    'Message' => "Success",
                    'Results' => $deleteId,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("Not Granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch (EloquentException $e){
            DbTrans::rollback();
            $result = [
                'Message' => $e->getMessage(),
                'Results' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }

    public function createTask(){
        try{
            if($this->isGranted()){
                // $user = $this->getUseraccount();
                $task = new T_taskdetails;
                $task->Type = 1;
                $task->Status = 1;
                $task->parseFromRequest(true);
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

    public function getMyTasks($projectid){
        try{
            $user = $this->getUseraccount();
            if(!empty($user)){
                $type = $this->request->getGet("type");

                $project = M_projects::find($projectid);

                $params = [
                    "where" => [
                        "M_Project_Id" => $project->Id
                    ],
                    "order" => [
                        "Created" => "DESC"
                    ]
                    
                ];
                $tasks = T_tasks::findAll($params);
                $taskdetail = [];
                

                foreach($tasks as $t){
                    $p = [
                        "where" => [ 
                            "M_User_Id" => $user->Id,
                            "Type" => $type
                        ],
                        "order" => [
                            "Created" => "DESC"
                        ]
                    ];
                    $value = $t->get_list_T_Taskdetail($p);
                    if(count($value) > 0){
                        $t->TasksDetail = $value;
                        $taskdetail[] = $t;
                    }
                        
                    
                    
                }

                // $taskp = [
                //     "where" => [
                //         "M_Project_Id" => $id
                //     ],
                //     "order" => [
                //         'Id' => "DESC"
                //     ]
                // ];
                // $project->Backlogs = T_tasks::findAll($taskp);
                // foreach($project->Backlogs as $backlog){
                //     $backlog->Tasks = $backlog->get_list_T_taskdetail(['order' => ['M_User_Id' => "ASC"]]);
                //     foreach($backlog->Tasks as $detail){
                //         $detail->AssignTo = $detail->get_M_User()->Name;
                //     }
                // }

                // $project->Teams = $teams;
                // $project->StrStatus = M_enumdetails::findEnumName("ProjectStatus", $project->Status);
                

                $result = [
                    'Message' => "Sukses",
                    'Results' => $taskdetail,
                    'Status' => ResponseCode::OK
                ];
                // $decoded = JWT::decode($jwt, $key, array('HS256')); 
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("User is not granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch (EloquentException $e){
            $result = [
                'Message' => $e->getMessage(),
                'Results' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }
}