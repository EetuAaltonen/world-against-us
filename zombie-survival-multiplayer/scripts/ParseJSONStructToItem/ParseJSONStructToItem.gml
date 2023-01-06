function ParseJSONStructToItem(_jsonStruct)
{
	var item = undefined;
	try
	{
		var itemStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(itemStruct) <= 0) return item;
		
		var databaseItem = global.ItemData[? itemStruct[$ "name"]];
		if (is_undefined(databaseItem)) return item;
		item = databaseItem.Clone();
		
		item.metadata = ParseMetadataItem(itemStruct[$ "metadata"], item.type);
		item.quantity = itemStruct[$ "quantity"] ?? 1;
		if (bool(itemStruct[$ "is_rotated"] ?? false)) { item.Rotate(); }
		item.known = bool(itemStruct[$ "known"] ?? true);
		
		if (!is_undefined(itemStruct[$ "grid_index"] ?? undefined)) {
			item.grid_index = new GridIndex(itemStruct[$ "grid_index"].col, itemStruct[$ "grid_index"].row);
		}
	} catch (error)
	{
		show_debug_message(error);
	}
	return item;
}