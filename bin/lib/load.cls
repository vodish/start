<?php
class load
{
    static	$layout		=	'';
    static	$tpl		=	'';
    
    static	$body		=	'';
    static	$title		=	'';
    static	$class		=	'';
    static  $url        =   '';
    
    static	$user;
    static  $db;
    
    static function renderpage()
    {
        if ( !isset($_GET['`tpl']) )   return ;
        
        
        self::$layout	=    $_GET['`tpl'];
        self::$url      =    self::urlparse($_SERVER['REQUEST_URI']);
//         self::$db       =   new db();
        
        
        do {
            self::$tpl	=	self::$layout;
            ob_start();
            require_once 'tpl/' .self::$layout;
            self::$body	=	ob_get_clean();
        }
        while ( self::$tpl != self::$layout );
        
        echo self::$body;
        
        exit;
    }
    
    
    static function makefile($mkfile, $mktpl, $addtime=true)
    {
        $dir	=	$_SERVER['DOCUMENT_ROOT']. dirname($mkfile);
        if ( !file_exists($dir) ) mkdir($dir, 0770, true);
        
        $ttpl	=	filemtime(dirname(dirname(__FILE__)).'/'.$mktpl);
        $tfile	=	file_exists($_SERVER['DOCUMENT_ROOT'].$mkfile)?		filemtime($_SERVER['DOCUMENT_ROOT'].$mkfile):	0;
        
        if ( $tfile != $ttpl ) {
            ob_start();
            require_once $mktpl;
            file_put_contents( $_SERVER['DOCUMENT_ROOT'].$mkfile, ob_get_clean(), LOCK_EX );
            
            if ( !touch($_SERVER['DOCUMENT_ROOT'].$mkfile, $ttpl) )
            {
                echo $mkfile;
            }
        }
        return $mkfile. ($addtime? '?'.$ttpl: '');
    }
    
    
    
    
    
    static function urlparse($url)
    {
        $parse         =   parse_url($url);
        $parse['dir']  =   explode('/', trim($parse['path'], '/'));
        
        if ( isset($parse['query']) ) {
            parse_str($parse['query'], $parse['query']);
        }
        
        return $parse;
    }
    
    
    
    
    static function user()
    {
        if ( empty($_COOKIE['user']) || !is_array($_COOKIE['user']) )	return array();
        
        $user  =   $_COOKIE['user'];
        
        return	$user;
    }
    
    
    
    
    
    
    static function redir($url)
    {
        header('Location: '. $url);
        die;
    }
    
    
    
    static function gethost()
    {
        $host	=	$_SERVER['HTTP_HOST'];
        $host	=	preg_replace('#:\d+$#', '', $host); #убрать порт
        return $host;
    }
    
    static function setcookie($name, $value)
    {
        $year	=	20 + date('Y');
        $host	=	self::gethost();
        $t		=	setcookie($name, $value, mktime(1,1,1, 1,1,$year), '/', $host );
    }
    
    static function delcookie($name)
    {
        $host=	self::gethost();
        $t	 =	setcookie($name, '', (time()-1), '/', $host);
    }
    
    
    static function print_r($var, $var_damp=false)
    {
        if ( $var_damp ) {
            echo '<pre>'; var_dump($var); echo '</pre>';
        } else {
            echo '<pre>'; print_r($var); echo '</pre>';
        }
    }
    
    
    static function checkval($arr, $key, $value)
    {
        return (!isset($arr[$key])  || $arr[$key]!=$value)?  false:  true;
    }
    
    
    static function typograf($text)
    {
        #в на они соединить
        $text	=	preg_replace("#(?<=\s\S)(\S{0,2}) (?=.)#", '$1&nbsp;', $text);
        $text	=	preg_replace("# -#", ' &mdash;', $text);
        
        return	$text;
    }
}