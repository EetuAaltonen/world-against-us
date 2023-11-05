function ParseJSONStructToArray(_jsonStruct, _jsonStructParseFunction)
{
	var parsedElements = [];
	try
	{
		if (is_array(_jsonStruct))
		{
			if (script_exists(_jsonStructParseFunction))
			{
				var arrayLength = array_length(_jsonStruct);
				for (var i = 0; i < arrayLength; i++)
				{
					var jsonStructElement = _jsonStruct[i];
					array_push(parsedElements, script_execute(_jsonStructParseFunction, jsonStructElement));
				}
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedElements;
}