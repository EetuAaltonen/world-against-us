function ParseJSONStructToDatabaseSkeletalSpriteAnimationEvent(_jsonStruct)
{
	var parsedEventData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedEventData;
		var eventDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(eventDataStruct) <= 0) return parsedEventData;
		
		parsedEventData = new SkeletalSpriteAnimationEventData(
			eventDataStruct[$ "object_event_type"] ?? ev_step,
			eventDataStruct[$ "event_name"] ?? undefined,
			eventDataStruct[$ "event_function"] ?? undefined
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedEventData;
}