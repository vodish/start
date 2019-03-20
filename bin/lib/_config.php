<?php
session_start();
error_reporting(E_ALL | E_NOTICE);
ini_set('display_errors'    , (PATH_SEPARATOR==';'? 'On': 'Off') );
ini_set('include_path'      , ini_get("include_path"). PATH_SEPARATOR. dirname(dirname(__FILE__)) );
ini_set('magic_quotes_gpc'  , 'Off');
spl_autoload_register(
    function ($name)
    {
        $dir    =   ini_get("include_path");
        $dir    =   strrchr($dir, PATH_SEPARATOR);
        $dir    =   substr( $dir, 1);
        $file   =   $dir. '/lib/' .$name . '.cls';
        
        if ( file_exists($file) )    require_once $file;
}
);


load::makefile('/.htaccess', 'tpl/_htaccess.txt');
load::makefile('/index.php', 'tpl/_index.tpl');

load::renderpage();