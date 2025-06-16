function ParseJSONStructToItem(_jsonStruct)
{
	var parsedItem = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedItem;
		var itemStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(itemStruct) <= 0) return parsedItem;
		
		parsedItem = global.ItemDatabase.GetItemByName(
			itemStruct[$ "name"] ?? undefined,
			itemStruct[$ "quantity"] ?? 1
		);
		if (is_undefined(parsedItem)) return parsedItem;
		
		var parsedIsRotated = bool(itemStruct[$ "is_rotated"]) ?? false;
		if (parsedItem.is_rotated != parsedIsRotated)
		{
			parsedItem.Rotate();
		}
		
		parsedItem.is_known = bool(itemStruct[$ "is_known"] ?? true);
		
		var gridIndex = itemStruct[$ "grid_index"] ?? undefined;
		if (!is_undefined(gridIndex)) {
			parsedItem.grid_index = new GridIndex(gridIndex.col, gridIndex.row);
		}
		
		// PARSE COMBINED METADATA
		var metadataStruct = itemStruct[$ "metadata"] ?? undefined;
		parsedItem.metadata = ParseJSONStructToItemMetadata(metadataStruct, parsedItem);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedItem;
}