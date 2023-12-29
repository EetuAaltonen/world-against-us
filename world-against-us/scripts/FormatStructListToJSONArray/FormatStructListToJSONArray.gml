function FormatStructListToJSONArray(_structList)
{
	var jsonItemArray = [];
	var valueCount = ds_list_size(_structList);	
	for (var i = 0; i < valueCount; i++)
	{
		var struct = _structList[| i];
		if (!is_undefined(struct))
		{
			array_push(jsonItemArray, struct.ToJSONStruct());
		}
	}
	return jsonItemArray;
}