<?php
class email
{
	private $boundary;
	public	$type			=	'text/plain';	# 'text/html';		'multipart/mixed';
	public	$charset		=	'utf-8';		# 'windows-1251';	; 'koi8-r'			'x-mac-cyrillic';
	public	$encoding		=	'8bit';
	public	$attach			=	'';
	public	$maxFileSize	=	0x400000; //4Mb
	public	$parameters		=	'';//'-fmail@mail.com';
	
	public	$from			=	'Start<mail@mail.com>';
	public  $to;
	public  $cc;
	public  $bc;
	public  $subject;
	public  $message;
	public	$regards;
	
	public function __construct($to='', $subject='', $message='')
	{
		$this->boundary	= 	md5(uniqid(rand(), true));
		
		$this->to		=	$to;
		$this->cc		=	'';
		$this->bc		=	'';
		$this->subject	=	$subject;
		$this->message	=	$message;
	}
	
	
	#Отправить сообщение
	public function send($regard=true)
	{
		#сообщение с подписью или без
		$message	=	!$regard?	$this->message:	$this->message. $this->regards();
		
		
		#кодирование
		$from		=	$this->convert( $this->from );
		$to			=	$this->convert( $this->to );
		$cc			=	$this->convert( $this->cc );
		$bc			=	$this->convert( $this->bc );
		$subject	=	$this->convert( $this->subject );
		$message	=	$this->convert( $message );
		
		
		#копия
		$temp[ $cc ]	=	"\n".	'Cc: ' .$cc;
		$temp[ ''  ]	=	'';
		$Cc		=	$temp[ $cc ];
		
		#скрытая копия
		$temp[ $bc ]	=	"\n".	'Bcc: ' .$bc;
		$temp[ ''  ]	=	'';
		$Bc		=	$temp[ $bc ];
		
		
		#заголовки
		$headers	=	'MIME-Version: 1.0'.
				"\n".	'X-Mailer: PHP/' .phpversion().
				"\n".	'From: ' .$from.
				$Cc.
				$Bc.
				"\n".	'Content-type: ' .$this->type. '; charset=' .$this->charset. ';';
		
		
		
		if ( !empty($this->attach) )
		{
			
			#заголовки
			$headers	=	'MIME-Version: 1.0'.
					"\n".	'X-Mailer: PHP/' .phpversion().
					"\n".	'From: ' .$from.
							$Cc.
							$Bc.
					"\n".	'Content-type: multipart/mixed; boundary = "' .$this->boundary. '"';
			
			#сообщение
			$message	=	"\n\n".		'--' .$this->boundary.
							"\n".		'Content-type: ' .$this->type.'; charset=' .$this->charset.';'.
							"\n".		'Content-Transfer-Encoding: ' .$this->encoding.
							"\n\n".
							$message.
							$this->attach.
							//"\n".		$this->boundary. '--'.
							//"\n\n"
							'';
		}
		
		return mail($to, $subject, $message, $headers, $this->parameters);
	}
	
	
	
	#Приложить файл
	public function attach($file,  $fileName)
	{
		#проверить путь к файлу
		if ( file_exists($file) )
		{
			if ( ($fileSize = filesize($file)) > $this->maxFileSize ) return ;
			
			#прочитать и кодировать файл
			$fp			 = fopen($file, 'r' );
			$content	 = chunk_split(base64_encode(fread( $fp, $fileSize+1)));
			fclose($fp);
		}
		#или это уже содержание файла
		else
		{
			$content	 = chunk_split(base64_encode($file));
		}
		
		
		#заголовок файла
		$this->attach	.=
					"\n\n".	'--' .$this->boundary.				
					"\n".	'Content-type: application/octet-stream; name = "' .$fileName. '"'.		
					"\n".	'Content-Transfer-Encoding: base64'.
					"\n".	'Content-Disposition: attachment; filename = "' .$fileName.'"'.
					"\n\n".	$content;
		
	}
	
	
	
	#добавление подписи к сообщению
	private function regards()
	{
		$text =	"\n\n\n".
				//'STORY1'. "\n".
				'STORY1 лабораторная неокономики'. "\n";
				//'/ send '.date('Y-m-d H:i:s');
		
		return	$text;
	}
	
	
	private function convert($text)
	{
		return $text;
		
		switch ($this->charset)
		{
			case 'utf-8'			: return	iconv( 'CP1251', 'UTF-8', $text );
			case 'koi8-r'			: return	convert_cyr_string( $text, 'w', 'k' );
			case 'x-mac-cyrillic'	: return	convert_cyr_string( $text, 'w', 'm' );
			default					: return	$text;
		}
	}
	
}
