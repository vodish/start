<!DOCTYPE html>
<html lang="ru">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8;" />
	<title><?= load::$title ?></title>
	
	<link href="<?= load::makefile('/bootstrap.css', 'inc/bootstrap.css') ?>" rel="Stylesheet" />
	<link href="<?= load::makefile('/css.css', 'inc/css.css') ?>" rel="Stylesheet" />
	
	<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
	<!--
	<link rel="icon" href="/favicon.ico" type="image/x-icon" />
	<link type="image/x-icon" href="/favicon.ico" rel="icon"/>
	<link type="image/x-icon" href="/favicon.ico" rel="shortcut icon"/>
	 -->
</head>
<body class="<?= load::$class ?>">
	
<div class="container">
	<div class="row">
		<div class="col-md-12">
			<?= load::$body ?>
		</div>
	</div>
</div>
	
	
<script src="<?= load::makefile('/jquery-2.1.4.min.js', 'inc/jquery-2.1.4.min.js') ?>" type="text/javascript"></script>
<script src="<?= load::makefile('/bootstrap.js', 'inc/bootstrap.js') ?>" type="text/javascript"></script>
<script src="<?= load::makefile('/js.js', 'inc/js.js') ?>" type="text/javascript"></script>
	
</body>
</html>