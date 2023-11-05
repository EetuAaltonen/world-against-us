function FormatItemListToJSONArray(_itemsList)
{
	var jsonItems = [];
	var itemCount = ds_list_size(_itemsList);	
	for (var i = 0; i < itemCount; i++)
	{
		var item = _itemsList[| i];
		if (!is_undefined(item))
		{
			array_push(jsonItems, item.ToJSONStruct());
		}
	}
	return jsonItems;
}