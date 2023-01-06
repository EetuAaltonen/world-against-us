function DatabaseFetchItemDataFromFile(_fileName)
{
	var itemData = ds_map_create();
	var filePath = string("{0}{1}", working_directory, _fileName);
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
			var formattedItem = ParseItemJSONStruct(jsonStruct);
			ds_map_add(itemData, formattedItem.name, formattedItem);
		}
	}
	return itemData;
}