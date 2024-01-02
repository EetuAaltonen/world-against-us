function ParseJSONStructToGameSaveDataLastLocation(_jsonStruct)
{
	var parsedLastLocation = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedLastLocation;
		var lastLocationStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(lastLocationStruct) <= 0) return lastLocationStruct;
		
		var parsedPosition = ParseJSONStructToVector2(lastLocationStruct[$ "position"]);
		parsedLastLocation = new GameSaveDataLastLocation(
			parsedPosition,
			lastLocationStruct[$ "room_index"] ?? ROOM_DEFAULT
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedLastLocation;
}