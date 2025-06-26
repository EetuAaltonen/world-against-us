function ParseJSONStructToInventoryFilter(_jsonStruct)
{
	var parsedInventoryFilter = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedInventoryFilter;
		var inventoryFilterStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(inventoryFilterStruct) <= 0) return parsedInventoryFilter;
		
		parsedInventoryFilter = new InventoryFilter(
			inventoryFilterStruct[$ "whitelisted_names"] ?? [],
			inventoryFilterStruct[$ "whitelisted_categories"] ?? [],
			inventoryFilterStruct[$ "whitelisted_types"] ?? []
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedInventoryFilter;
}