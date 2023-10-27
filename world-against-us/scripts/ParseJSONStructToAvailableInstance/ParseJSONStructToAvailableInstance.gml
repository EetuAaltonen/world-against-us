function ParseJSONStructToAvailableInstance(_jsonStruct)
{
	var parsedAvailableInstance = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedAvailableInstance;
		var availableInstanceStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(availableInstanceStruct) <= 0) return parsedAvailableInstance;
		
		var parsedInstanceId = availableInstanceStruct[$ "instance_id"] ?? -1;
		if (parsedInstanceId != -1)
		{
			var parsedRoomIndex = availableInstanceStruct[$ "room_index"] ?? undefined;
			var parsedPlayerCount = availableInstanceStruct[$ "player_count"] ?? -1;
		
			parsedAvailableInstance = new AvailableInstance(
				parsedInstanceId,
				parsedRoomIndex,
				parsedPlayerCount
			);
		} else {
			show_message("ParseMapIcon: Map icon parse error");
			throw (string(availableInstanceStruct));
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedAvailableInstance;
}