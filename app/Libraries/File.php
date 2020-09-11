<?php

namespace App\Libraries;

use DateTime;
use DateTimeZone;
use \CodeIgniter\HTTP\Files\UploadedFile;

class File
{

    protected $filetype = array();
    protected $maxsize;
    protected $urlfile = "";
    protected $destination = false;

    public $errormsg = "";

    public function __construct($destination, array $filetype = array(), $maxsize = 0)
    {
        if (!$this->destination)
            $this->destination = $destination;

        $this->filetype = $filetype;
        $this->maxsize = $maxsize;
    }

    public function upload(UploadedFile $files, $usePrefixName = true)
    {

        if ($this->maxsize != 0 && $files->getSize() > $this->maxsize) {

            $this->errormsg = lang('File.size_too_large');
            return false;
        }

        if (!empty($filetype))
            if (!in_array($this->getExtension($files), $this->filetype)) {

                $this->errormsg = lang('File.extension_not_allowed');
                return false;
            }

        if (!file_exists(FCPATH. $this->destination))
            mkdir(FCPATH . $this->destination, 0777, true);
        $nameex = "";
        if ($usePrefixName) {
            $date = new DateTime('now', new DateTimeZone('Asia/Jakarta'));
            $nameex = $date->format("Ymd_His");
        }

        if (move_uploaded_file($files->getTempName(), FCPATH . $this->destination . DIRECTORY_SEPARATOR . $nameex . str_replace(" ","-",$files->getName()))) {

            $this->urlfile = $this->destination . "/" . $nameex . str_replace(" ","-",$files->getName());
            return true;
        }

        return false;
    }

    public function getFileUrl()
    {
        return $this->urlfile;
    }

    public function getErrorMessage()
    {
        return $this->errormsg;
    }

    public function getExtension(UploadedFile $files)
    {
        return pathinfo($files->getExtension(), PATHINFO_EXTENSION);
    }

    public function setExtension($fileType)
    {
        if (is_array($fileType)) {
            $this->filetype = $fileType;
            return $this;
        }

        $this->filetype = [];
        array_push($this->filetype, $fileType);
        return $this;
    }

    public function addExtension($fileType)
    {
        array_push($this->filetype, $fileType);
        return $this;
    }
    
}
