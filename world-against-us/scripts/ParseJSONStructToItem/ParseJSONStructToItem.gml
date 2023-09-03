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
		
		if (bool(itemStruct[$ "is_rotated"] ?? false)) { parsedItem.Rotate(); }
		
		parsedItem.is_known = bool(itemStruct[$ "is_known"] ?? true);
		
		if (!is_undefined(itemStruct[$ "grid_index"] ?? undefined)) {
			parsedItem.grid_index = new GridIndex(itemStruct[$ "grid_index"].col, itemStruct[$ "grid_index"].row);
		}
		
		// COMBINE METADATA WITH DATABASE METADATA
		var metadataStruct = itemStruct[$ "metadata"] ?? undefined;
		if (!is_undefined(metadataStruct))
		{
			var metadataStructNames = variable_struct_get_names(metadataStruct);
			var structVariableNameCount = array_length(metadataStructNames);
			for (var i = 0; i < structVariableNameCount; i++)
			{
				var metadataValueName = metadataStructNames[@ i];
				var metadataValue = metadataStruct[$ metadataValueName] ?? undefined;
				if (!is_undefined(metadataValue))
				{
					variable_struct_set(parsedItem.metadata, metadataValueName, metadataValue);
				}
			}
		}
		// PARSE COMBINED METADATA
		parsedItem.metadata = ParseJSONStructToMetadataItem(parsedItem.metadata, parsedItem.category, parsedItem.type);
		
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedItem;
}