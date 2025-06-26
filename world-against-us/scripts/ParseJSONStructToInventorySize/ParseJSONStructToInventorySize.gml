function ParseJSONStructToInventorySize(_jsonStruct)
{
	var parsedInventorySize = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedInventorySize;
		var inventorySizeStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(inventorySizeStruct) <= 0) return parsedInventorySize;
		
		parsedInventorySize = new InventorySize(
			inventorySizeStruct[$ "columns"],
			inventorySizeStruct[$ "rows"]
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedInventorySize;
}