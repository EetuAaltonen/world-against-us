function ParseJSONStructToPatrol(_jsonStruct)
{
	var parsedPatrol = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedPatrol;
		var patrolStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(patrolStruct) <= 0) return parsedPatrol;
		
		var parsedRouteProgress = ScaleIntPercentToFloat(patrolStruct[$ "scaled_route_progress"] ?? 0);
		parsedPatrol = new Patrol(
			patrolStruct[$ "patrol_id"] ?? -1,
			patrolStruct[$ "ai_state"] ?? -1,
			patrolStruct[$ "travel_time"] ?? 0,
			parsedRouteProgress
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedPatrol;
}