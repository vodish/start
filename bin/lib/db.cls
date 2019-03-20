<?php
class db
{
    public	$connect;
    public	$result;
    public	$error;
    
    
    
    public function __construct($host, $db, $user, $pass)
    {
        //if ( PATH_SEPARATOR==';' ) $host .= ':3355';
        
        
        $this->connect = mysqli_connect( $host , $user , $pass, $db ) or	die("<pre>Error database connect, host: <b>$host</b>, user: <b>$user</b></pre>");
        
        mysqli_set_charset($this->connect, 'utf8');
        
        $this->set_db($db);
    }
    
    public function set_db($dbname)
    {
        mysqli_select_db($this->connect, $dbname) or $this->print_sql(mysqli_error($this->connect));
    }
    
    
    
    
    private function replace($query)
    {
        $query	=	preg_replace("#SLEEP\([^)]*\)#i", '', $query);
        return $query;
    }
    
    # Функция произвольного запроса
    public function query($query='', $vars=array())
    {
        foreach ($vars as $k => $v)    $query = str_replace($k, $this->v($v), $query);
        
        $this->result	=	mysqli_query($this->connect, $this->replace($query)) or $this->print_sql($query);
    }
    
    
    public function fetch()
    {
        return	mysqli_fetch_assoc($this->result);
    }
    
    
    
    
    public function multi($query='', $key='')
    {
        mysqli_multi_query($this->connect, $this->replace($query)) or $this->print_sql($query);
        
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
    
    
    
    public function select($query, $id='', $field='') // Выбрать из БД
    {
        $this->query($query);
        
        if ( $field != '' )
        {
            $row  =   $this->fetch();
            
            return $row[ $field ];
        }
        
        if ( $id=='' ) {
            for ($var=array();  $row=$this->fetch();  $var[]=$row);
            //return mysqli_fetch_all($result, MYSQLI_ASSOC);
        }
        else{
            for ($var=array();  $row=$this->fetch();  $var[ $row[$id] ]=$row);
        }
        
        return $var;
    }
    
    
    
    
    public function print_sql($query)
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
    
    
    
    
    
    
    
    public function lastId ()
    {
        return mysqli_insert_id ( $this->connect );
    }
    
    public function v($value)
    {
        if ( is_array($value) )
        {
            foreach ($value as $k=>$v)
            {
                $value[ $k ] = mysqli_real_escape_string($this->connect, $v);
            }
        }
        else {
            $value =   mysqli_real_escape_string($this->connect, $value);
        }
        
        return $value;
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
