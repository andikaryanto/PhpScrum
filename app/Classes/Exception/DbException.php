<?php
namespace App\Classes\Exception;
use App\Classes\Exception\BaseException;
use Exception;
use Throwable;

class DbException extends BaseException {
    
    
    public function __construct($message = "", $code = 0, ?Throwable $previous = null)
    {
        parent::__construct($message, $code, $previous);
    }
}