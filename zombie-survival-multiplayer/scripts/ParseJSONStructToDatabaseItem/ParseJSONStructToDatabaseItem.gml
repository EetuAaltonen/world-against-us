function ParseJSONStructToDatabaseItem(_jsonStruct)
{
	var item = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return item;
	
			var icon = GetSpriteByName(_jsonStruct[$ "icon"]);
			var size = new Size(
				_jsonStruct[$ "size"].w,
				_jsonStruct[$ "size"].h
			);
			var quantity = 1;
			var itemType = _jsonStruct[$ "type"];
			var metadata = ParseMetadataItem(_jsonStruct[$ "metadata"], itemType);
	
			item = new Item(
				_jsonStruct[$ "name"],
				_jsonStruct[$ "short_name"],
				icon,
				size,
				itemType,
				_jsonStruct[$ "weight"],
				_jsonStruct[$ "max_stack"],
				_jsonStruct[$ "base_price"],
				_jsonStruct[$ "description"],
				quantity,
				metadata,
				false,		// IS ROTATED
				true,		// IS KNOWN
				undefined	// GRID INDEX
			);
		} catch (error)
		{
			show_message(error);
		}
	}
	return item;
}