function ParseJSONStructToPlayerData(_jsonStruct)
{
	var parsedPlayer = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedPlayer;
		var playerStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(playerStruct) <= 0) return parsedPlayer;
		
		var parsedPosition = ParseJSONStructToVector2(playerStruct[$ "position"] ?? undefined)
		parsedPlayer = new PlayerData(
			playerStruct[$ "network_id"] ?? UNDEFINED_UUID,
			playerStruct[$ "name"] ?? "RemotePlayer",
			parsedPosition
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPlayer;
}