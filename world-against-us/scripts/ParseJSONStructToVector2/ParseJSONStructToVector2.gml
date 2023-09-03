function ParseJSONStructToVector2(_jsonStruct)
{
	var parsedVector2 = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedVector2;
		var vector2Struct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(vector2Struct) <= 0) return parsedVector2;
		
		parsedVector2 = ScaleIntValuesToFloatVector2(
			vector2Struct[$ "X"] ?? 0,
			vector2Struct[$ "Y"] ?? 0,
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedVector2;
}