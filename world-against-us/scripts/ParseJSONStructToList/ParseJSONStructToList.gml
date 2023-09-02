function ParseJSONStructToList(_jsonStruct, _jsonStructParseFunction)
{
	var list = ds_list_create();
	try
	{
		if (is_array(_jsonStruct))
		{
			if (script_exists(_jsonStructParseFunction))
			{
				var arrayLength = array_length(_jsonStruct);
				for (var l = 0; l < arrayLength; l++)
				{
					var jsonStructElement = _jsonStruct[l];
					ds_list_add(list, script_execute(_jsonStructParseFunction, jsonStructElement));
				}
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return list;
}