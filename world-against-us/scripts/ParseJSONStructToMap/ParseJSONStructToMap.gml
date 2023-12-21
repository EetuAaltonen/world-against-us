function ParseJSONStructToMap(_mapRef, _jsonStruct, _mapKeyIndicator, _elementParseFunction)
{
	try
	{
		if (is_array(_jsonStruct))
		{
			if (script_exists(_elementParseFunction))
			{
				var arrayLength = array_length(_jsonStruct);
				for (var i = 0; i < arrayLength; i++)
				{
					var parsedData = script_execute(_elementParseFunction, _jsonStruct[i]);
					if (!is_undefined(parsedData[$ _mapKeyIndicator]))
					{
						ds_map_add(_mapRef, parsedData[$ _mapKeyIndicator], parsedData);
					} else {
						throw (string("Struct is missing {0} property in some where", _mapKeyIndicator));
					}
				}
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
}