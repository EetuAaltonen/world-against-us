function ParseJSONStructArrayToMap(_structArray, _mapKeyIndicator, _elementParseFunction)
{
	var dataMap = ds_map_create();
	if (!is_undefined(_structArray))
	{
		try
		{
			if (script_exists(_elementParseFunction))
			{
				var arrayLength = array_length(_structArray);
				for (var i = 0; i < arrayLength; i++)
				{
					var parsedData = script_execute(_elementParseFunction, _structArray[i]);
					if (!is_undefined(parsedData[$ _mapKeyIndicator]))
					{
						ds_map_add(dataMap, parsedData[$ _mapKeyIndicator], parsedData);
					} else {
						throw (string("Struct is missing {0} property in some where", _mapKeyIndicator));
					}
				}
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	return dataMap;
}