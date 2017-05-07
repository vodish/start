<?php
class pass
{
	static $timeout	=	array();
	
	static function gen($length=8)
	{
		$ret	=	'';
		
		for ($x=0; $x<$length; $x++)
		{
			$rand	=	rand(0,1)%2?	rand(65, 90):	rand(97, 122);
			
			$ret	.=	chr( $rand );
		}
		
		return	$ret;
	}
	
	
	static function enterpassEncode($user)
	{
		return	md5($user['id']. $user['pass']. $user['pass']); 
	}
	
	static function enterlinkEncode($user)
	{
		return 'http://' .$_SERVER['HTTP_HOST']. '/reg/pass/?change&email=' .$user['email']. '&key=' .self::enterpassEncode($user);
	}
	 
	
	static function timeout($datetime, $timeout=600)
	{
		$datetime	=	empty($datetime)? '0000-00-00 00:00:00': $datetime;
		
		#распарсить время перемен профиля
		#проверить таймаут 10мин = 60*10 = 600сек
		preg_match('|(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})|', $datetime, $a);
		
		$timout	=	mktime($a[4], $a[5], $a[6], $a[2], $a[3], $a[1]) + $timeout - time();
		
		if ( $timout > 0 )
		{
			$m		=	floor( $timout / 60 );
			$s		=	$timout % 60;
			
			return	self::$timeout	= array( 'm'=>$m , 's'=>$s );
		}
		
		
		return 	self::$timeout	=	array();
	}
}
