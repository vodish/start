# start
Это стартовый шаблон для создания сайта по MVC модели.

# как работает
1. смотрим /www/.htaccess
   там подключается ../bin/lib/_config.php
2. смотрим /bin/lib/_config.php
   там подключаются все настроки и вызов главного медода load::renderpage() внутри которого происходит сборка шаблонов сайта из папки /bin/tpl 

# принцип шаблонов
1. в файле /bin/tpl/_htaccess.txt настраиваем какой шиблон будет отображен для какой страницы, через передачу переменной `tpl=main.tpl
2. далее в шаблоне main.tpl определяестя в какой шаблон будет вставлен результат работы (принцип матрёшки)
3. если не указать вышестоящий шаблон, то сборка шаблонов прекращается, а результат выводится в браузер.

# статические файлы
1. для работы со статическими текстровыми страницами (*.css, *.js и др.) используется метод load::makefile('/.htaccess', 'tpl/_htaccess.txt'), где перевым параметром указывается путь к создаваемому файлу, а вторым - путь к шаблону
2. бонус для файлов *.css - в шаблонах стилей можно использовать язык php, для генерации содержимого, те. получаем встроенный препроцессор
