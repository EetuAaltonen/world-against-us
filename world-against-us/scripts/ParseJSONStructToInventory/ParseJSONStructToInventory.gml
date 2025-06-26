function ParseJSONStructToInventory(_jsonStruct)
{
	var parsedInventory = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedInventory;
		var inventoryStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(inventoryStruct) <= 0) return parsedInventory;
		
		var sizeStruct = inventoryStruct[$ "size"];
		if (is_undefined(sizeStruct)) return parsedInventory;
		var inventoryFilterStruct = inventoryStruct[$ "inventory_filter"];
		if (is_undefined(inventoryFilterStruct)) return parsedInventory;
		
		var parsedInventorySize = ParseJSONStructToInventorySize(sizeStruct);
		var parsedInventoryFilter = ParseJSONStructToInventoryFilter(inventoryFilterStruct);
		var itemCountLimitStruct = inventoryStruct[$ "item_count_limit"] ?? -1;
		var parsedItemCountLimit = (itemCountLimitStruct == -1) ? infinity : itemCountLimitStruct;
		parsedInventory = new Inventory(
			inventoryStruct[$ "inventory_id"] ?? undefined,
			inventoryStruct[$ "type"] ?? undefined,
			parsedInventorySize,
			parsedInventoryFilter,
			parsedItemCountLimit
		);
		var parsedItems = ParseJSONStructToArray(inventoryStruct[$ "items"] ?? [], ParseJSONStructToItem);
		// POPULATE INVENTORY WITH ITEMS
		parsedInventory.AddMultipleItems(parsedItems);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedInventory;
}