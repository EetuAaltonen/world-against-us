function ParseJSONStructToItemArray(_jsonStruct)
{
	var itemArray = [];
	try
	{
		if (is_array(_jsonStruct))
		{
			var itemCount = array_length(_jsonStruct);
			for (var l = 0; l < itemCount; l++)
			{
				var item = _jsonStruct[l];
				array_push(itemArray, ParseJSONStructToItem(item));
			}
		}
	} catch (error)
	{
		show_debug_message(error);
	}
	return itemArray;
}