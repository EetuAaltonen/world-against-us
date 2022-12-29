function FormatDataMapFromFile(_data, _mapKeyIndicator, _formatJSONFunction)
{
	var formatData = ds_map_create();
	var dataCount = array_length(_data);
	for (var i = 0; i < dataCount; i++)
	{
		var jsonStruct = _data[i];
		if (script_exists(_formatJSONFunction))
		{
			var structData = script_execute(_formatJSONFunction, jsonStruct);
			ds_map_add(formatData, structData[$ _mapKeyIndicator], structData);
		}
	}
	return formatData;
}