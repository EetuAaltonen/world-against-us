function ParseJSONStructToScoutingDroneData(_jsonStruct)
{
	var parsedScoutingDrone = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedScoutingDrone;
		var scoutingDroneStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(scoutingDroneStruct) <= 0) return parsedScoutingDrone;
		
		var parsedRegionId = scoutingDroneStruct[$ "region_id"];
		var parsedPosition = ParseJSONStructToVector2(scoutingDroneStruct[$ "position"] ?? undefined);
		parsedScoutingDrone = new ScoutingDroneData(
			parsedRegionId,
			parsedPosition
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedScoutingDrone;
}