function ParseJSONStructToInventory(_jsonStruct)
{
	var parsedInventory = undefined;
	
	try
	{
		var inventoryStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(inventoryStruct) <= 0) return parsedInventory;
		
		parsedInventory = {
			inventory_id: inventoryStruct[$ "inventory_id"] ?? undefined,
			inventory_type: inventoryStruct[$ "inventory_type"] ?? undefined,
			items: []
		};
						
		var itemsArrayStruct = inventoryStruct[$ "items"] ?? [];
		var itemCount = array_length(itemsArrayStruct);
		for (var i = 0; i < itemCount; i++)
		{
			var itemStruct = itemsArrayStruct[@ i];
			var item = ParseJSONStructToItem(itemStruct);
			array_push(parsedInventory.items, item);
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	
	return parsedInventory;
}