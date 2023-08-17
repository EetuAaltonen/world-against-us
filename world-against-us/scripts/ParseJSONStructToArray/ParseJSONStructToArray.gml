function ParseJSONStructToArray(_jsonStruct, _jsonStructParseFunction)
{
	var array = [];
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
					array_push(array, script_execute(_jsonStructParseFunction, jsonStructElement));
				}
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return array;
}