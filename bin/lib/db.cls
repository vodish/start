<?php
class db
{
	public	$connect;
	public	$result;
	public	$error;
	
	public function __construct($host, $db, $user, $pass, $port='3306')
	{
		$this->connect = mysqli_connect ( $host , $user , $pass, $db, $port ) or	die("<pre>Error database connect, host: <b>$host</b>, user: <b>$user</b></pre>");
		
		mysqli_query ($this->connect, "SET NAMES 'utf8'" );
		if ( !mysqli_select_db($this->connect, $db ))	die ('Could not connect: ' .mysqli_error($this->connect, $this->connect) );
	}
	
	
	private function replace($query)
	{
		$query	=	str_replace(array('[',']'), array('`','`'), $query);
		return $query;
	}
	
	
	public function select($query, $id='') // Выбрать из БД
	{
		$this->result	=	mysqli_query($this->connect, $this->replace($query)) or $this->PrintSql($query);
		
		if ( $id=='' ) {
			for ($var=array();  $row=$this->fetch();  $var[]=$row);
			//return mysqli_fetch_all($result, MYSQLI_ASSOC);
		}
		else{
			for ($var=array();  $row=$this->fetch();  $var[ $row[$id] ]=$row);
		}
		
		return $var;
	}
	
	
	public function PrintSql($query)
	{
		if ( PATH_SEPARATOR==';' )
		{
			echo '<div style="color: red;">Error: ' .mysqli_error($this->connect). '</div>';
			echo '<pre>';  print_r ($query);  echo '</pre>';
		}
		else
		{
			echo '<div style="color: red;">Database error...</div>';
		}
		die;
	}
	
	
	# Функция произвольного запроса
	public function query($query='')
	{
		$this->result	=	mysqli_query($this->connect, $this->replace($query)) or $this->PrintSql($query);
	}
	
	
	function fetch()
	{
		return	mysqli_fetch_assoc($this->result);
	}
	
	
	public function multi($query='', $key='')
	{
		mysqli_multi_query($this->connect, $this->replace($query)) or $this->PrintSql($query);
		
		$return	=	array();
		
		do {
			if ($res = $this->connect->store_result())
			{
				//$return[] = $res->fetch_all(MYSQLI_ASSOC);
				for ($var=array();  $row=$this->fetch();  $var[]=$row);
				$return[] =  $var;
				$res->free();
			}
		} while ($this->connect->more_results() && $this->connect->next_result());
		
		
		return	isset($return[$key])?  $return[$key]:  $return;
	}
	
	# Функция показать ID последней добавленной записи
	public function lastId ()
	{
		return mysqli_insert_id ( $this->connect );
	}
	
	public function v($value)
	{
		return	mysqli_real_escape_string($this->connect, $value);
	}
	
	public function v2input($value)
	{
		return	str_replace('"', '&#034;', $value);
	}

	public function restore_result()
	{
		if ( $this->connect->next_result() )
		{
			$this->connect->store_result();
			//while($this->connect->next_result()) $this->connect->store_result();
		}
	}
	
}
?>
