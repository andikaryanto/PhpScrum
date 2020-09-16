<?php
namespace App\Controllers\Rests;

use App\Classes\Exception\EloquentException;
use App\Controllers\Rests\Base_Rest;
use App\Eloquents\T_commentattachments;
use App\Eloquents\T_comments;
use App\Libraries\DbTrans;
use App\Libraries\File;
use App\Libraries\ResponseCode;
use Firebase\JWT\JWT;

class Comments extends Base_Rest {
    public function __construct()
    {
        parent::__construct();
    }

    public function createComment(){
        try{
            DbTrans::beginTransaction();
            if($this->isGranted()){
                $user = $this->getUseraccount();
                $comment = new T_comments();
                $comment->parseFromRequest();
                $comment->M_User_Id = $user->Id;
                $comment->validate();
                
                if($comment->save()){

                    $keys = [];
                    foreach($_FILES as $key => $files){
                        $file = new File("assets/commentfiles");
                        $cifiles = $this->request->getFiles()[$key];
                        if($file->upload($cifiles)){
                            $commentattachment = new T_commentattachments();
                            $commentattachment->T_Comment_Id = $comment->Id;
                            $commentattachment->FileName = $cifiles->getName();
                            $commentattachment->Type = $cifiles->getClientExtension();
                            $commentattachment->UrlFile = $file->getFileUrl();
                            if(!$commentattachment->save()){
                                throw new EloquentException("Failed to save image", $comment, ResponseCode::FAILED_SAVE_DATA);
                            }
                        } else {
                            throw new EloquentException("Failed to upload file or more", $comment, ResponseCode::FAILED_SAVE_DATA);
                        }

                    }

                    $result = [
                        'Message' => "Success",
                        'Result' => $keys,
                        'Status' => ResponseCode::OK
                    ];
                    $this->response->setStatusCode(200)->setJSON($result)->sendBody();
                } else {
                    throw new EloquentException("Failed to save data", $comment, ResponseCode::FAILED_SAVE_DATA);
                }
                DbTrans::rollback();
            } else {
                throw new EloquentException("Not Granted", null, ResponseCode::NO_ACCESS_USER_MODULE);
            }
        } catch (EloquentException $e){
            DbTrans::rollback();
            $result = [
                'Message' => $e->getMessage(),
                'Result' => null,
                'Status' => $e->getReponseCode()
            ];
            $this->response->setStatusCode(400)->setJSON($result)->sendBody();
        }
    }
}