FileAPI.event.on(choose, 'change', function (evt){
	
	var files = FileAPI.getFiles(evt); // Retrieve file list

	//alert(files);
	for ( var f=0; f<files.length; f++ )
	{
		
		// Загружаем файлы
		FileAPI.upload({
			url: './index.php?newupload',
			row: '?',
			files: { images: files[f] },
			fileupload: function (file/**Object*/, options/**Object*/){
				
				var tpl = document.getElementById('tpl');
				var row = this.row = tpl.cloneNode(true);
				
				row.id = options.uid;
				row.getElementsByTagName('B')[0].innerHTML = file.name;
				row.getElementsByTagName('SPAN')[0].innerHTML = 0 + '%';
				
				tpl.parentNode.appendChild(row);
			},
			progress: function (evt){
				
				this.row.getElementsByTagName('SPAN')[0].innerHTML = Math.round(evt.loaded/evt.total * 100) + '%';
			},
			complete: function (err/**String*/, xhr/**Object*/, file/**Object/, options/**Object*/){
				if( !err ){
					var data	=	JSON.parse(xhr.response);
			    	this.row.id =	'f' + data.file.id;
			    	this.row.getElementsByTagName('A')[0].href = data.file.path;
			    	this.row.getElementsByTagName('SPAN')[0].innerHTML = data.file.size;
					
			    	var orderlink =	document.getElementById('orderlink');
			    	orderlink.href=	'/?orderlink=' + data.key;
			    	orderlink.parentNode.style.display = 'block';
			    }
			}
		});
	}
});


function RemoveFile(t)
{
	$.ajax({
	  url: './?removefile=' + t.parentNode.id.substring(1)
	}).done(function(data) {
		if (data=='remove:ok') {
			t.parentNode.parentNode.removeChild(t.parentNode);
		}	
	});
}


