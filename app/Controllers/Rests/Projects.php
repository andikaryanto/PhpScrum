<?php
namespace App\Controllers\Rests;

use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\M_enumdetails;
use App\Eloquents\M_positions;
use App\Eloquents\M_profiles;
use App\Eloquents\M_projects;
use App\Eloquents\M_users;
use App\Eloquents\T_projectinteracts;
use App\Eloquents\T_tasks;
use App\Libraries\DbTrans;
use App\Libraries\ResponseCode;
use Firebase\JWT\JWT;

class Projects extends Base_Rest {
    public function __construct()
    {
        parent::__construct();
    }

    public function getProjects(){
        if($this->isGranted()){
            $user = $this->getUseraccount();
            if(!empty($user)){
                $params = [
                    "where" => [
                        "M_User_Id" => $user->Id
                    ],
                    "order" => [
                        "M_Project_Id" => "DESC"
                    ]
                    
                ];
                $projects = T_projectinteracts::findAll($params);

                $allProjects = [];

                foreach($projects as $p){
                    $project = $p->get_M_Project();
                    $project->StrStatus = M_enumdetails::findEnumName("ProjectStatus", $project->Status);
                    $project->IsYours = $project->CreatedBy == $user->Username;
                    // $project->CreatedBy = $p->get_M_User()->Name;
                    $allProjects[] = $project;
                }

                $result = [
                    'Message' => "Sukses",
                    'Results' => $allProjects,
                    'Status' => ResponseCode::OK
                ];
                // $decoded = JWT::decode($jwt, $key, array('HS256')); 
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                $result = [
                    'Message' => "Failed",
                    'Result' => [],
                    'Status' => ResponseCode::NO_DATA_FOUND
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            }
        }
    }


    public function getProject($id){
        if($this->isGranted()){
            $user = $this->getUseraccount();
            if(!empty($user)){

                $project = M_projects::find($id);

                $params = [
                    "where" => [
                        "M_Project_Id" => $project->Id
                    ],
                    "order" => [
                        "M_Project_Id" => "DESC"
                    ]
                    
                ];
                $interact = T_projectinteracts::findAll($params);
                $teams = [];

                foreach($interact as $i){
                    $p = [
                        "where" => [ "M_User_Id" => $i->M_User_Id]
                    ];


                    // $user = M_users::find($i->M_User_Id);
                    // $user->Profile = M_profiles::findOne($p);
                    $profile = M_profiles::findOne($p);
                    $profile->Name = M_users::find($i->M_User_Id)->Name;
                    $profile->Position = $profile->get_M_Position()->Position;
                    $teams[] = $profile;
                    
                }

                $taskp = [
                    "where" => [
                        "M_Project_Id" => $id
                    ],
                    "order" => [
                        'Id' => "DESC"
                    ]
                ];
                $project->Backlogs = T_tasks::findAll($taskp);
                $taskDone = 0;
                $alltaskCount = 0;
                foreach($project->Backlogs as $backlog){
                    $backlog->Tasks = $backlog->get_list_T_taskdetail(['order' => ['M_User_Id' => "ASC"]]);
                    foreach($backlog->Tasks as $detail){
                        ++$alltaskCount;
                        if($detail->Type == 5){
                            $taskDone++;
                        }
                        $detail->AssignTo = $detail->get_M_User()->Name;
                    }
                }
                $project->ProjectDone = round($taskDone / $alltaskCount * 100);
                $project->Teams = $teams;
                $project->IsYours = $project->CreatedBy == $user->Username;
                $project->StrStatus = M_enumdetails::findEnumName("ProjectStatus", $project->Status);
                

                $result = [
                    'Message' => "Sukses",
                    'Result' => $project,
                    'Status' => ResponseCode::OK
                ];
                // $decoded = JWT::decode($jwt, $key, array('HS256')); 
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                $result = [
                    'Message' => "Failed",
                    'Result' => [],
                    'Status' => ResponseCode::NO_DATA_FOUND
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            }
        }
    }

    public function createProject(){
        if($this->isGranted()){
            $user = $this->getUseraccount();
            $project = new M_projects();
            $project->parseFromRequest(true);
            $teams = (array)$this->request->getJson()->Teams;
            $project->M_User_Id = $user->Id;

            DbTrans::beginTransaction();
            try{
                $project->validate();
                if($project->save()){
                    $interactproject = new T_projectinteracts();
                    $interactproject->M_Project_Id = $project->Id;
                    $interactproject->M_User_Id = $user->Id;
                    if(!$interactproject->save()){
                        throw new EloquentException("Failed To Save Data", $project, ResponseCode::FAILED_SAVE_DATA);
                    }

                    foreach($teams as $t){

                        $teaminteract = new T_projectinteracts();
                        $teaminteract->M_Project_Id = $project->Id;
                        $teaminteract->M_User_Id = $t;
                        if(!$teaminteract->save()){
                            throw new EloquentException("Failed To Save Data", $project, ResponseCode::FAILED_SAVE_DATA);
                        }
                    }

                    DbTrans::commit();
                    $result = [
                        'Message' => "Success",
                        'Result' => [$project],
                        'Status' => ResponseCode::OK
                    ];
                    $this->response->setStatusCode(200)->setJSON($result)->sendBody();
                } else {
                    throw new EloquentException("Failed To Save Data", $project, ResponseCode::FAILED_SAVE_DATA);
  
                }

            } catch (EloquentException $e){
                DbTrans::rollback();
                $result = [
                    'Message' => $e->getMessages(),
                    'Result' => $project,
                    'Status' => $e->getReponseCode()
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            }
            // if(!empty($user)){
            //     $params = [
            //         "where" => [
            //             "M_User_Id" => $user->Id
            //         ],
            //         "order" => [
            //             "M_Project_Id" => "DESC"
            //         ]
                    
            //     ];
            //     $projects = T_projectinteracts::findAll($params);

            //     $allProjects = [];

            //     foreach($projects as $p){
            //         $project = $p->get_M_Project();
            //         $project->StrStatus = M_enumdetails::findEnumName("ProjectStatus", $project->Status);
            //         $allProjects[] = $project;
            //     }

                // $result = [
                //     'Message' => "Sukses",
                //     'Results' => $teams,
                //     'Status' => ResponseCode::OK
                // ];
                // // $decoded = JWT::decode($jwt, $key, array('HS256')); 
                // $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            // } else {
            //     $result = [
            //         'Message' => "Failed",
            //         'Result' => [],
            //         'Status' => ResponseCode::NO_DATA_FOUND
            //     ];
            //     $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            // }
        }
    }

    public function deleteProject($id){
        if($this->isGranted()){
            try{

                $project = M_projects::find($id);
                if($project->delete()){
                    $result = [
                        'Message' => "$project->Name Removed",
                        'Result' => $project,
                        'Status' => ResponseCode::OK
                    ];
                    $this->response->setStatusCode(200)->setJSON($result)->sendBody();
                } else {
                    throw new EloquentException("", null, null);
                }
            } catch(EloquentException $e){
                $result = [
                    'Message' => "Cant Remove $project->Name ",
                    'Result' => $project,
                    'Status' => ResponseCode::FAILED_DELETE_DATA
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            }
        }
    }

    public function addTeam($id){

        if($this->isGranted()){
            try{
                DbTrans::beginTransaction();
                $teams = (array)$this->request->getJSON()->TeamIds;
                
                $p = [
                    'where' => [
                        "M_Project_Id" => $id
                    ]
                ];
                $projectinteract = T_projectinteracts::findAll($p);

                foreach($projectinteract as $pi){
                    if(!$pi->delete()){
                        throw new EloquentException("Cant Delete Teams", $teams, ResponseCode::FAILED_DELETE_DATA);
                    }
                }

                foreach($teams as $team){
                     $interact = new T_projectinteracts();
                     $interact->M_Project_Id = $id;
                     $interact->M_User_Id = $team;
                     if(!$interact->save()){
                        throw new EloquentException("Cant Add Teams", $teams, ResponseCode::FAILED_DELETE_DATA);
                     }
                }
                DbTrans::commit();
                $result = [
                    'Message' => "Teams Added",
                    'Result' => $teams,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } catch(EloquentException $e){
                DbTrans::rollback();
                $result = [
                    'Message' => $e->getMessage(),
                    'Result' => $e->getEntity(),
                    'Status' => $e->getReponseCode()
                ];
                $this->response->setStatusCode(400)->setJSON($result)->sendBody();
            }
        }
    }
}