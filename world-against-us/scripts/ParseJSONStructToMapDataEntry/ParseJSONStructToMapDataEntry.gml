function ParseJSONStructToMapDataEntry(_jsonStruct)
{
	var parsedMapDataEntry = undefined;
	try
	{
		var entryStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(entryStruct) <= 0) return parsedMapDataEntry;
		
		var parsedObjectName = entryStruct[$ "object_name"] ?? UNDEFINED_OBJECT_NAME;
		if (parsedObjectName != UNDEFINED_OBJECT_NAME)
		{
			var parsedPosition = ParseJSONStructToVector2(entryStruct[$ "position"] ?? undefined);
			var parsedSize = ParseJSONStructToSize(entryStruct[$ "size"] ?? undefined);
			var mapIconStyle = GetMapIconStyleByObjectName(parsedObjectName);
		
			parsedMapDataEntry = new MapDataEntry(
				parsedObjectName,
				parsedPosition,
				parsedSize,
				mapIconStyle,
				entryStruct[$ "icon_alpha"] ?? undefined
			);
		} else {
			show_message("ParseMapDataEntry: Map data entry parse error");
			throw (string(entryStruct));
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedMapDataEntry;
}