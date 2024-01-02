function ParseJSONStructToGameSaveDataPlayerData(_jsonStruct)
{
	var parsedPlayerData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedLastLocation;
		var playerDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(playerDataStruct) <= 0) return playerDataStruct;
		
		var parsedCharacter = ParseJSONStructToGameSaveDataCharacter(playerDataStruct[$ "character"]);
		var parsedLastLocation = ParseJSONStructToGameSaveDataLastLocation(playerDataStruct[$ "last_location"]);
		parsedPlayerData = new GameSaveDataPlayerData(
			parsedCharacter,
			parsedLastLocation,
			undefined
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPlayerData;
}