function ParseJSONStructToPatrol(_jsonStruct)
{
	var parsedPatrol = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedPatrol;
		var patrolStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(patrolStruct) <= 0) return parsedPatrol;
		
		var parsedPosition = ParseJSONStructToVector2(patrolStruct[$ "position"] ?? undefined);
		parsedPatrol = new Patrol(
			patrolStruct[$ "patrol_id"] ?? -1,
			patrolStruct[$ "region_id"] ?? -1,
			patrolStruct[$ "ai_state"] ?? AI_STATE_BANDIT.TRAVEL,
			patrolStruct[$ "travel_time"] ?? 0,
			patrolStruct[$ "route_progress"] ?? 0,
			patrolStruct[$ "target_network_id"] ?? UNDEFINED_UUID,
		);
		parsedPatrol.position = parsedPosition;
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPatrol;
}