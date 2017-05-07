<?php
$work	=	empty($_POST)?  0:  1;

class field
{
	public $value	= '';
	public $alert	= false;
	public $info	= false;
	
	public $work;
	
	
	public function __construct($value, $work)
	{
		if ($work)
		{
			$this->work  = $work;
			$this->value = $value;
		}
	}
	
	public function lower()
	{
		$this->value = strtolower($this->value);
	}
	
	/**
	 * Пустое / непустое
	 *
	 * @param unknown_type $value
	 */
	public function cEmpty ($value='непустое')
	{
		if ($this->work && !$this->alert) {
			
			$this->value = trim($this->value);
			
			$var = $this->value===''? 'пустое' : 'непустое';
			
			if ( $value!=$var ) {
				$this->alert = true;
				
				if ($value=='непустое') {
					$this->info = 'не заполнено';
				}elseif ($value=='пустое') {
					$this->info = 'заполнено';
				}
			}
		}
		
		$this->info = $this->ln($this->info);
	}
	
	
	/**
	 * Длина строки
	 *
	 * @param unknown_type $start
	 * @param unknown_type $finish
	 */
	public function cLength ($start, $finish)
	{
		if ($this->work && !$this->alert)
		{
			$var = strlen($this->value);
			
			if ( $var < $start || $var > $finish )
			{
				$this->alert = true;
				$this->info = $this->ln('от'). ' ' .$start. ' ' .$this->ln('до'). ' ' .$finish. ' ' .$this->ln('символов');
			}
		}
	}
	
	
	/**
	 * Размер числа
	 * 
	 *  @param integr $start = 0
	 *  @param integr $start = 100
	 * */
	public function cSize ($start, $finish)
	{
		if ($this->work && !$this->alert)
		{
			$var	=	0 + $this->value;
			
			if ( $var < $start || $var > $finish )
			{
				$this->alert = true;
				$this->info = 'Ваша картинка весит ' .( round($this->value/1024) ). ' Кб (а должна быть от ' .($start/1024). '&mdash;' .($finish/1024). ' Кб)';
			}
		}
	}
	
	
	
	/**
	 * Сравнение с регулярным выражением
	 *
	 * @param unknown_type $expr
	 */
	public function cPattern ($expr, $info='некорректное значение')
	{
		if ($this->work && !$this->alert)
		{
			if ( !preg_match($expr, $this->value, $m) )
			{
				$this->alert	=	true;
				$this->info		=	$info;
			}
		}
		
		$this->info = $this->ln($this->info);
	}
	
	
	/**
	 * Проверка email
	 */
	public function cEmail()
	{
		if ($this->work && !$this->alert)
		{
			if ( !preg_match('/^[-a-z0-9_.]+@[-a-z0-9_.]+\.[a-z]{2,4}$/i', $this->value) )
			{
				$this->alert	=	true;
				$this->info		=	'некорректное значение';
			}
			
			$this->info	=	$this->ln($this->info);
		}
	}
	
	
	/**
	 * Сравнение со значением
	 *
	 * @param string $patern
	 * @param bool $result
	 * @param реистр $registr
	 */
	public function cMatch ($patern, $result=true, $registr='ON')
	{
		if ($this->work && !$this->alert)
		{
			if ($registr=='OFF') {
				$var = strtoupper($patern)==strtoupper($this->value) ? true : false;
			} else {
				$var = $patern==$this->value ? true : false;
			}
			
			if ($var!==$result) {
				$this->alert = true;
				$this->info = 'сравнение неудачно';
			}
		}
		
		$this->info = $this->ln($this->info);
	}
	
	
	public function ln($value)
	{
		$temp[ 'непустое' ][ 'ru' ]	=	'непустое';
		$temp[ 'непустое' ][ 'en' ]	=	'not empty';
		
		$temp[ 'пустое' ][ 'ru' ]	=	'пустое';
		$temp[ 'пустое' ][ 'en' ]	=	'empty';
		
		$temp[ 'не заполнено' ][ 'ru' ]	=	'не заполнено';
		$temp[ 'не заполнено' ][ 'en' ]	=	'empty';
		
		$temp[ 'заполнено' ][ 'ru' ]	=	'заполнено';
		$temp[ 'заполнено' ][ 'en' ]	=	'full';
		
		$temp[ 'некорректное значение' ][ 'ru' ]	=	'некорректное значение';
		$temp[ 'некорректное значение' ][ 'en' ]	=	'not correct value';
		
		$temp[ 'сравнение неудачно' ][ 'ru' ]	=	'сравнение неудачно';
		$temp[ 'сравнение неудачно' ][ 'en' ]	=	'comparison fails';
		
		$temp[ 'от' ][ 'ru' ]	=	'от';
		$temp[ 'от' ][ 'en' ]	=	'start';
		
		$temp[ 'до' ][ 'ru' ]	=	'до';
		$temp[ 'до' ][ 'en' ]	=	'finish';
		
		$temp[ 'символов' ][ 'ru' ]	=	'символов';
		$temp[ 'символов' ][ 'en' ]	=	'symbol';
		
		$lang	=	'ru';
		
		if ( isset($temp[ $value ])  &&  isset($temp[ $value ][ $lang ]) )
		{
			return $temp[ $value ][ $lang ];
		}
		else
		{
			return $value;
		}
	}
	
}
