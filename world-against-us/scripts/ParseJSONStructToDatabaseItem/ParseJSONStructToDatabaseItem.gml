function ParseJSONStructToDatabaseItem(_jsonStruct)
{
	var parsedItem = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedItem;
		var itemStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(itemStruct) <= 0) return parsedItem;
	
		var icon = GetSpriteByName(itemStruct[$ "icon"] ?? undefined);
		var size = ParseJSONStructToSize(itemStruct[$ "size"] ?? undefined, false);
		var itemCategory = itemStruct[$ "category"] ?? undefined;
		var itemType = itemStruct[$ "type"] ?? undefined;
		var metadata = ParseJSONStructToMetadataItem(itemStruct[$ "metadata"] ?? undefined, itemCategory, itemType);
		
		parsedItem = new Item(
			itemStruct[$ "name"] ?? undefined,
			itemStruct[$ "short_name"] ?? EMPTY_STRING,
			icon,
			size,
			itemCategory,
			itemType,
			itemStruct[$ "weight"] ?? 0,
			itemStruct[$ "max_stack"] ?? 1,
			itemStruct[$ "base_price"] ?? 0,
			itemStruct[$ "description"] ?? EMPTY_STRING,
			1,			// DEFAULT QUANTITY
			metadata,
			false,		// DEFAULT IS ROTATED
			true,		// DEFAULT IS KNOWN
			undefined	// DEFAULT GRID INDEX
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedItem;
}