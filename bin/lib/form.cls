<?php
class form
{
	public $alert	=	true;
	
	public $session	=	'form';
	public $input	=	'_a';
	
	public $value	=	'';
	
	public $add		=	0;
	public $id		=	'';
	
	
	public function __construct($method='post')
	{
		$this->protect($method);
		
	}
	
	public function protect($method)
	{
		
		$request=	$method=='post'? $_POST: $_GET;
		
		$form	=	0 + @$request[ $this->input ];
		$sess	=	0 + @$_SESSION[ $this->session ];
		
		/*print_r($form);
		echo ' = ';
		print_r($sess);*/
		
		if ( $form && $sess && $form==$sess )
		{
			$this->alert	=	false;
		}
		
		#меняем значения
		$this->value	=	rand(999999, 9999999);
		$_SESSION[ $this->session ]	=	$this->value;
		
		
		#защита через js
		$this->add	=	rand(9, 999);
		$this->id	=	$this->input . $this->add;
	}
	
	
	
	public function alert($work, $text='')
	{
		if ( $work && $this->alert )
		{
			echo !empty($text)?  $text:  '<div class="r">Защита от роботов &mdash; отправьте форму вручную.</div>';
		}
	} 
	
	
	public function input()
	{
		echo '<input id="' .$this->id. '" type="hidden" name="' .$this->input. '" value="' .($this->value+$this->add). '" />';
	}
	
	public function js()
	{
		?>
		<script type="text/javascript">
			function Submit() {
				var i = '<?=$this->input?>';
				var m = <?=$this->add?>;
				var t = document.getElementById(i+m);
				t.value = t.value-m;
			}
		</script>
		<?
	}
	
	public function onclick()
	{
		echo 'Submit();';
	}
	
	
}