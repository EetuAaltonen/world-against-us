function ParseJSONStructToSize(_jsonStruct)
{
	var parsedSize = undefined;
	try
	{
		var sizeStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(sizeStruct) <= 0) return parsedSize;
		
		parsedSize = ScaleIntValuesToFloatSize(
			sizeStruct[$ "w"] ?? 0,
			sizeStruct[$ "h"] ?? 0,
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedSize;
}