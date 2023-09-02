function ParseJSONStructToDatabaseMapIconStyleData(_jsonStruct)
{
	var mapIconStyleData = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return mapIconStyleData;
			
			var objectName = _jsonStruct[$ "object_name"] ?? undefined;
			if (!is_undefined(objectName))
			{
				var objectIndex = asset_get_index(objectName);
				if (objectIndex > -1)
				{
					// TODO: Use RGBA struct
					var colorStruct = _jsonStruct[$ "color"];
					var rgbColor = make_color_rgb(
						colorStruct[$ "red"] ?? 0,
						colorStruct[$ "green"] ?? 0,
						colorStruct[$ "blue"] ?? 0
					);
				
					mapIconStyleData = new MapIconStyle(
						objectName,
						rgbColor,
						bool(_jsonStruct[$ "constant_alpha"] ?? true),
						bool(_jsonStruct[$ "is_dynamic"] ?? false)
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
	}
	return mapIconStyleData;
}