function ParseJSONStructToDatabaseMapIconStyleData(_jsonStruct)
{
	var mapIconStyleData = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return mapIconStyleData;
			
			var objectIndex = asset_get_index(_jsonStruct[$ "obj_index"] ?? noone);
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
					objectIndex,
					rgbColor,
					_jsonStruct[$ "constant_alpha"] ?? true
				);
			} else {
				throw (string("Unable to load a map icon color for {0}", _jsonStruct[$ "obj_index"])); 
			}
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return mapIconStyleData;
}