function JSONStructToItem(_jsonStruct)
{
	var itemData = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
	
	if (variable_struct_names_count(itemData) <= 0) return undefined;
	
	var icon = is_string(itemData[$ "icon"]) ? asset_get_index(itemData[$ "icon"]) : itemData[$ "icon"];
	var quantity = is_undefined(itemData[$ "quantity"]) ? 1 : itemData[$ "quantity"]; // DEFAULT QUANTITY TO 1
	var size = new Size(
		itemData[$ "size"].w,
		itemData[$ "size"].h
	);
	
	return new Item(
		itemData[$ "name"],
		icon,
		size,
		itemData[$ "type"],
		itemData[$ "weight"],
		itemData[$ "max_stack"],
		itemData[$ "base_price"],
		itemData[$ "description"],
		quantity,
		itemData[$ "metadata"],
		itemData[$ "rotated"],
		itemData[$ "known"],
		itemData[$ "source_type"],
		itemData[$ "grid_index"]
	);
}
