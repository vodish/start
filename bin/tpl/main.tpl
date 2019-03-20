<?php
load::$layout	=	'default.tpl';
load::$title	=	'start';

#определения
$main   =   new main();
$foo    =   $main->foo();

?>

<h1>Start</h1>
<?
load::print_r(load::$url);
load::print_r($foo);
?>
