itemData = ds_map_create();

var filePath = (working_directory + "item_data.json");
if (file_exists(filePath))
{
	var json = "";
	var file = file_text_open_read(filePath);
	
	while (file_text_eof(file) == false)
	{
		json += file_text_readln(file);	
	}
	file_text_close(file);
	var data = json_parse(json)[$ "item_data"];
	var dataCount = array_length(data);
	
	for (var i = 0; i < dataCount; i++)
	{
		var jsonStruct = data[i];
		var formattedItem = JSONStructToItem(jsonStruct);
		ds_map_add(itemData, formattedItem.name, formattedItem);
	}
}

bulletData = ds_map_create();
ds_map_add(bulletData, 7.62, spr762Bullet);
ds_map_add(bulletData, 9, spr9mmBullet);