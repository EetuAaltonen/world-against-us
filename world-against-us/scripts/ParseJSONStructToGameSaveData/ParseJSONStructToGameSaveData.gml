function ParseJSONStructToGameSaveData(_jsonStruct)
{
	var parsedGameSaveData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedGameSaveData;
		var gameSaveStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(gameSaveStruct) <= 0) return gameSaveStruct;
		
		var playerDataStruct = ParseJSONStructToGameSaveDataPlayerData(gameSaveStruct[$ "player_data"]);
		parsedGameSaveData = new GameSaveData(
			playerDataStruct
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedGameSaveData;
}