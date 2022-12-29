function ReadDataFromJSONFile(_fileName, _arrayName, _formatFunction = undefined, _mapKeyIndicator = "name", _formatStructFunction = undefined)
{
	var data = [];
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
		data = json_parse(json)[$ _arrayName];
		
		if (!is_undefined(_formatFunction))
		{
			if (script_exists(_formatFunction))
			{
				// INSERT DATA TO ARGUMENTS ARRAY 
				data = script_execute_ext(_formatFunction, [data, _mapKeyIndicator, _formatStructFunction]);
			}
		}
	}
	return data;
}