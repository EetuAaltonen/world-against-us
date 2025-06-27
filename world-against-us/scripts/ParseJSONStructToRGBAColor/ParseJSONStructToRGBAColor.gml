function ParseJSONStructToRGBAColor(_jsonStruct)
{
	var parsedRGBAColor = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedRGBAColor;
		var rgbaColorStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(rgbaColorStruct) <= 0) return parsedRGBAColor;
		
		parsedRGBAColor = new RGBAColor(
			rgbaColorStruct[$ "red"] ?? 255,
			rgbaColorStruct[$ "green"] ?? 255,
			rgbaColorStruct[$ "blue"] ?? 255,
			rgbaColorStruct[$ "alpha"] ?? 0,
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedRGBAColor;
}