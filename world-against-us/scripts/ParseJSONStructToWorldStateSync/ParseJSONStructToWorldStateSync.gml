function ParseJSONStructToWorldStateSync(_jsonStruct)
{
	var parsedWorldStateSync = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedWorldStateSync;
		var syncStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(syncStruct) <= 0) return parsedWorldStateSync;
	
		var parsedDateTime = ParseJSONStructToWorldStateDateTime(syncStruct[$ "date_time"] ?? undefined);
		parsedWorldStateSync = new NetworkWorldStateSync(
			parsedDateTime,
			syncStruct[$ "weather"] ?? undefined
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedWorldStateSync;
}