function ParseJSONStructToPatrolActionRob(_jsonStruct)
{
	var parsedPatrolActionRob = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedPatrolActionRob;
		var actionStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(actionStruct) <= 0) return parsedPatrolActionRob;
		
		parsedPatrolActionRob = new PatrolActionRob(
			actionStruct[$ "region_id"] ?? undefined,
			actionStruct[$ "patrol_id"] ?? undefined,
			actionStruct[$ "target_network_id"] ?? UNDEFINED_UUID,
			actionStruct[$ "target_player_tag"] ?? "Unknown"
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPatrolActionRob;
}