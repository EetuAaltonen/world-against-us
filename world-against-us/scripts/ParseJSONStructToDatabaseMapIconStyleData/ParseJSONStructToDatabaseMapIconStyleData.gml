function ParseJSONStructToDatabaseMapIconStyleData(_jsonStruct)
{
	var parsedMapIconStyleData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedMapIconStyleData;
		var mapIconStyleDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(mapIconStyleDataStruct) <= 0) return parsedMapIconStyleData;
			
		var objectName = mapIconStyleDataStruct[$ "object_name"] ?? undefined;
		if (!is_undefined(objectName))
		{
			var objectIndex = asset_get_index(objectName);
			if (objectIndex > -1)
			{
				// TODO: Use RGBA struct
				var colorStruct = mapIconStyleDataStruct[$ "color"] ?? EMPTY_STRUCT;
				var rgbColor = make_color_rgb(
					colorStruct[$ "red"] ?? 0,
					colorStruct[$ "green"] ?? 0,
					colorStruct[$ "blue"] ?? 0
				);
				
				parsedMapIconStyleData = new MapIconStyle(
					objectName,
					rgbColor,
					bool(mapIconStyleDataStruct[$ "constant_alpha"] ?? true),
					bool(mapIconStyleDataStruct[$ "is_dynamic"] ?? false)
				);
			} else {
				throw (string("Unable to find object index for {0} in map icon style parsing", objectName));
			}
		} else {
			throw (string("Trying to parse a map icon style with 'undefined' object name", objectName));
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedMapIconStyleData;
}