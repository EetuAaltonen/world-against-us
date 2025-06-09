function ParseJSONStructToDatabaseSkeletalSpriteAnimation(_jsonStruct)
{
	var parsedAnimationData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedAnimationData;
		var animationDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(animationDataStruct) <= 0) return parsedAnimationData;

		var parsedEvents = ds_map_create();
		ParseJSONStructToMap(parsedEvents, animationDataStruct[$ "events"], "event_name", ParseJSONStructToDatabaseSkeletalSpriteAnimationEvent);
		var parsedPlaybackFunction = asset_get_index(animationDataStruct[$ "playback_function"]);
		if (parsedPlaybackFunction == -1) { parsedPlaybackFunction = undefined; }
		var parsedDrawFunction = asset_get_index(animationDataStruct[$ "draw_function"]);
		if (parsedDrawFunction == -1) { parsedDrawFunction = undefined; }

		parsedAnimationData = new SkeletalSpriteAnimationData(
			animationDataStruct[$ "name"] ?? undefined,
			parsedEvents,
			parsedPlaybackFunction,
			parsedDrawFunction
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedAnimationData;
}