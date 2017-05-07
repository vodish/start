<?php
class load
{
	static	$layout		=	'';
	static	$tpl		=	'';
	
	static	$body		=	'';
	static	$title		=	'';
	static	$class		=	'';
	
	static	$db;
	static	$side;
	static	$user;
		
	
	static function renderpage()
	{
		self::$layout	=	(isset($_GET['tpl'])? $_GET['tpl']: 'main.tpl');
		if ( !file_exists('../bin/tpl/' .self::$layout) )	self::redir('/?404=template-unknown');
		
// 		self::$settpl	=	self::settpl();
// 		echo self::$settpl;
// 		die;
// 		require_once	'lib/db.cls';
// 		self::$db		=	new db();
		
		do {
			self::$tpl	=	self::$layout;
			ob_start();
			require_once 'tpl/' .self::$layout;
			self::$body	=	ob_get_clean();
		}
		while ( self::$tpl != self::$layout );
		
		echo self::$body;
	}
	
	
	
	static function makefile($mkfile, $mktpl)
	{
		$dir = $_SERVER['DOCUMENT_ROOT']. dirname($mkfile);
		if ( !file_exists($dir) ) mkdir($dir, 0770, true);
		
		$ttpl	=	filemtime(dirname(dirname(__FILE__)).'/'.$mktpl);
		$tfile	=	file_exists($_SERVER['DOCUMENT_ROOT'].$mkfile)?		filemtime($_SERVER['DOCUMENT_ROOT'].$mkfile):	0;
		
		if ( $tfile != $ttpl ) {
			ob_start();
			require_once $mktpl;
			file_put_contents( $_SERVER['DOCUMENT_ROOT'].$mkfile, ob_get_clean(), LOCK_EX );
			touch($_SERVER['DOCUMENT_ROOT'].$mkfile, $ttpl);
		}
		return $mkfile;
	}
	
	
	
	static function redir($url)
	{
		header('Location: '. $url);
		die;
	}
	
	
	static function user($id='')
	{
		$cookie	=	isset($_COOKIE['user'])?	$_COOKIE['user']:	'new';
		
		$user	=	self::$db->fetch( self::$db->query("SELECT *  FROM `user`  WHERE `id` = '" .$cookie. "' ") );
		
		if ( $user['id']==1 )
		{
			$user['admin'] = 1;
		}
		
		#активность пользователя
		self::$db->query("
			UPDATE
				`user`
			SET
				`ip` 		= '" .$_SERVER['REMOTE_ADDR']. "',
				`update`	= NOW()
			WHERE
				`id` = '" .$user['id']. "'
		");
		
		//load::print_r($user);
		return	$user;
	}
	
	
	
	static function mdate($date)
	{
		preg_match('#(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})#', $date, $m);
		
		
		$mount	=	array($m[2]=>'...', '01'=>'янв', '02'=>'фев', '03'=>'мар', '04'=>'апр', '05'=>'мая', '06'=>'июн', '07'=>'июл', '08'=>'авг', '09'=>'сен', '10'=>'окт', '11'=>'ноя', '12'=>'дек');
		
		$temp[ $m[1]	 ]	=	$m[1]. ' ';
		$temp[ date('Y') ]	=	'';
		$m[1]	=	$temp[ $m[1] ];
		
		return (0+$m[3]). ' ' .$mount[$m[2]]. $m[1]. '  <i>' .$m[4]. ':' .$m[5]. '</i>';
	} 
	
	
	
	
	
	
	
	static function gethost()
	{
		$host	=	$_SERVER['HTTP_HOST'];
		$host	=	preg_replace('#:\d+$#', '', $host); #убрать порт
		$e		=	array_reverse( explode('.', $host) );
		$host	=	preg_match("#\d#", $e[0])?  $host: ($e[1]. '.' .$e[0]); #взять ip или домен второго уровня
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
	
	
	static function print_r($var)
	{
		echo '<pre>'; print_r($var); echo '</pre>';
	}
	
}