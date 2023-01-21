function ParseJSONStructArrayToMap(_structArray, _mapKeyIndicator, _elementParseFunction)
{
	var dataMap = ds_map_create();
	if (!is_undefined(_structArray))
	{
		if (script_exists(_elementParseFunction))
		{
			var arrayLength = array_length(_structArray);
			for (var i = 0; i < arrayLength; i++)
			{
				var parsedData = script_execute(_elementParseFunction, _structArray[i]);
				ds_map_add(dataMap, parsedData[$ _mapKeyIndicator], parsedData);
			}
		}
	}
	return dataMap;
}