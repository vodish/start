AddDefaultCharset UTF-8
php_value	magic_quotes_gpc	Off
php_value	auto_prepend_file	../bin/lib/_config.mdl

RewriteEngine on
RewriteRule ^$		/index.php?%{QUERY_STRING}		[L]
#RewriteRule ^([^/]+)/$					/index.php?tpl=$1&%{QUERY_STRING}  [L]

