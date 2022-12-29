function JSONStructToItem(_jsonStruct)
{
	var itemData = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
	if (variable_struct_names_count(itemData) <= 0) return undefined;
	
	var icon = GetSpriteByIndex(itemData[$ "icon"]);
	var quantity = is_undefined(itemData[$ "quantity"]) ? 1 : itemData[$ "quantity"]; // DEFAULT QUANTITY TO 1
	var size = new Size(
		itemData[$ "size"].w,
		itemData[$ "size"].h
	);
	var itemType = itemData[$ "type"];	
	// PARSE METADATA
	var metadata = ParseItemMetadata(itemData[$ "metadata"], itemType);
	
	return new Item(
		itemData[$ "name"],
		icon,
		size,
		itemType,
		itemData[$ "weight"],
		itemData[$ "max_stack"],
		itemData[$ "base_price"],
		itemData[$ "description"],
		quantity,
		metadata,
		itemData[$ "is_rotated"],
		itemData[$ "known"],
		itemData[$ "grid_index"]
	);
}
