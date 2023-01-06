function ParseJSONStructToItem(_jsonStruct)
{
	var item = undefined;
	try
	{
		var itemStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(itemStruct) <= 0) return item;
		
		item = global.ItemData[? itemStruct[$ "name"]].Clone();
		if (is_undefined(item)) return item;
		
		item.metadata = ParseItemMetadata(itemStruct[$ "metadata"], item.type);
		item.quantity = itemStruct[$ "quantity"] ?? 1;
		if (bool(itemStruct[$ "is_rotated"] ?? false)) { item.Rotate(); }
		item.known = bool(itemStruct[$ "known"] ?? true);
		item.grid_index = itemStruct[$ "grid_index"];
		
	} catch (error)
	{
		show_debug_message(error);
	}
	return item;
}