function ParseJSONStructToPlayerListInfo(_jsonStruct)
{
	var parsedPlayerListInfo = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedPlayerListInfo;
		var playerInfoStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(playerInfoStruct) <= 0) return parsedPlayerListInfo;
		
		var parsedRoomIndex = playerInfoStruct[$ "room_index"] ?? EMPTY_STRING;
		var parsedRoomName = global.WorldMapLocationData[? parsedRoomIndex];
		parsedPlayerListInfo = new PlayerListInfo(
			playerInfoStruct[$ "player_name"] ?? EMPTY_STRING,
			playerInfoStruct[$ "instance_id"] ?? -1,
			parsedRoomIndex
		);
		parsedPlayerListInfo.room_name = parsedRoomName;
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPlayerListInfo;
}