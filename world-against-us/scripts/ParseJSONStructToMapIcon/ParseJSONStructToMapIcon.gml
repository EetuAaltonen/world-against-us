function ParseJSONStructToMapIcon(_jsonStruct)
{
	var parsedMapIcon = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedMapIcon;
		var mapIconStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(mapIconStruct) <= 0) return parsedMapIcon;
		
		var parsedObjectName = mapIconStruct[$ "object_name"] ?? UNDEFINED_OBJECT_NAME;
		if (parsedObjectName != UNDEFINED_OBJECT_NAME)
		{
			var parsedPosition = ParseJSONStructToVector2(mapIconStruct[$ "position"] ?? undefined);
			var parsedSize = ParseJSONStructToSize(mapIconStruct[$ "size"] ?? undefined);
			var mapIconStyle = GetMapIconStyleByObjectName(parsedObjectName);
		
			parsedMapIcon = new MapIcon(
				parsedObjectName,
				parsedPosition,
				parsedSize,
				mapIconStyle,
				mapIconStruct[$ "icon_alpha"] ?? undefined
			);
		} else {
			show_message("ParseMapIcon: Map icon parse error");
			throw (string(mapIconStruct));
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedMapIcon;
}