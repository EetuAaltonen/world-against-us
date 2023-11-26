function ParseJSONStructToJoinGameRequest(_jsonStruct)
{
	var parsedJoinGameRequest = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedJoinGameRequest;
		var requestStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(requestStruct) <= 0) return parsedJoinGameRequest;
	
		parsedJoinGameRequest = new NetworkJoinGameRequest(
			requestStruct[$ "instance_id"] ?? undefined,
			requestStruct[$ "room_index"] ?? undefined,
			requestStruct[$ "owner_client"] ?? UNDEFINED_UUID
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedJoinGameRequest;
}