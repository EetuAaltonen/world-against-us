function ReadJSONFile(_fileName)
{
	var jsonStruct = undefined;
	try
	{
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
			jsonStruct = json_parse(json);
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return jsonStruct;
}