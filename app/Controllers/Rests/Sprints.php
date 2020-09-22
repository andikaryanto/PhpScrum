<?php
namespace App\Controllers\Rests;

use AndikAryanto11\Exception\DatabaseException;
use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\M_enumdetails;
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
                $sprint = new T_sprints();
                $sprint->parseFromRequest(true);
                $sprint->IsActive = 1;
                $sprint->validate();

                $acitiveSprint = T_sprints::findOne(
                    [
                        'where' => [
                            "IsActive" => 1,
                            "M_Project_Id" => $sprint->M_Project_Id
                        ],

                    ]
                );

                if(!is_null($acitiveSprint)){
                    $acitiveSprint->IsActive = 0;
                    if(!$acitiveSprint->save()){
                        throw new EloquentException("Failed to deactivate previous Sprint", $sprint, ResponseCode::FAILED_SAVE_DATA);
                    }
                }

                if($sprint->save()){
                    $result = [
                        'Message' => "Success",
                        'Result' => $sprint,
                        'Status' => ResponseCode::OK
                    ];

                    $taskp = [
                        "join" => [
                            "t_tasks" => [[
                                'key' => 't_taskdetails.T_Task_Id = t_tasks.Id',
                                'type' => 'left'
                            ]],
                            "m_projects" => [[
                                'key' => 't_tasks.M_Project_Id = m_projects.Id',
                                'type' => 'left'
                            ]]
                        ],
                        "where" => [
                            "m_projects.Id" => $sprint->M_Project_Id,
                            
                        ],
                        "whereIn" => [
                            "t_taskdetails.Type" => [2,3,4]
                        ]
                    ];

                    $unfinishesStories = T_taskdetails::findAll($taskp);
                    foreach($unfinishesStories as $u){
                        $u->Type = 1;
                        if(!$u->save()){
                            throw new EloquentException("Failed to set Back Log", $u, ResponseCode::FAILED_SAVE_DATA);
                        }
                    }

                    DbTrans::commit();
                    $this->response->setStatusCode(200)->setJSON($result)->sendBody();
                } else {
                    throw new EloquentException("Failed to save data", $sprint, ResponseCode::FAILED_SAVE_DATA);
                }
            } else {
                throw new EloquentException("Not Granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch (EloquentException $e){
            DbTrans::rollback();
            $result = [
                'Message' => $e->getMessage(),
                'Result' => $e->getEntity(),
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }

    public function getSprints($id){
        try{
           
            if($this->isGranted()){
                $p = [
                    'where' =>[
                        "M_Project_Id" => $id
                    ], 
                    'order' => [
                        "Created" => "DESC"
                        ]
                ];
                $sprints = T_sprints::findAll($p);
                $result = [
                    'Message' => "Success",
                    'Results' => $sprints,
                    'Status' => ResponseCode::OK
                ];
                $this->response->setStatusCode(200)->setJSON($result)->sendBody();
            } else {
                throw new EloquentException("Not Granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
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

    public function test($id){
        $taskp = [
            "join" => [
                "t_tasks" => [[
                    'key' => 't_taskdetails.T_Task_Id = t_tasks.Id',
                    'type' => 'inner'
                ]],
                "m_projects" => [[
                    'key' => 't_tasks.M_Project_Id = m_projects.Id',
                    'type' => 'inner'
                ]]
            ],
            "where" => [
                "m_projects.Id" => $id,
                
            ],
            "whereIn" => [
                "t_taskdetails.Type" => [2,3,4]
            ]
        ];

        $unfinishesStories = T_taskdetails::findAll($taskp);
        $result = [
            'Message' => "Success",
            'Results' => $unfinishesStories,
            'Status' => ResponseCode::OK
        ];
        $this->response->setStatusCode(200)->setJSON($result)->sendBody();
    }
}