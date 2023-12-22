function ParseJSONStructToRegion(_jsonStruct)
{
	var parsedRegion = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedRegion;
		var regionStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(regionStruct) <= 0) return parsedRegion;
		var parsedLocalPlayersStructArray = regionStruct[$ "local_players"] ?? [];
		var parsedLocalPlayers = ParseJSONStructToArray(parsedLocalPlayersStructArray, ParseJSONStructToPlayerData);
		var parsedPatrolStructArray = regionStruct[$ "arrived_patrols"] ?? [];
		var parsedPatrols = ParseJSONStructToArray(parsedPatrolStructArray, ParseJSONStructToPatrol);
		parsedRegion = new Region(
			regionStruct[$ "region_id"] ?? -1,
			regionStruct[$ "room_index"] ?? undefined,
			regionStruct[$ "owner_client"] ?? UNDEFINED_UUID,
			parsedLocalPlayers,
			parsedPatrols
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedRegion;
}