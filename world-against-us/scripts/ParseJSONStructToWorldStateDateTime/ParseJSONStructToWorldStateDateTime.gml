function ParseJSONStructToWorldStateDateTime(_jsonStruct)
{
	var parsedDateTime = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedDateTime;
		var dateTimeStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(dateTimeStruct) <= 0) return parsedDateTime;
	
		parsedDateTime = new WorldStateDateTime();
		parsedDateTime.year = dateTimeStruct[$ "year"] ?? 0;
		parsedDateTime.month = dateTimeStruct[$ "month"] ?? 0;
		parsedDateTime.day = dateTimeStruct[$ "day"] ?? 0;
		parsedDateTime.hours = dateTimeStruct[$ "hours"] ?? 0;
		parsedDateTime.minutes = dateTimeStruct[$ "minutes"] ?? 0;
		parsedDateTime.seconds = dateTimeStruct[$ "seconds"] ?? 0;
		parsedDateTime.milliseconds = dateTimeStruct[$ "milliseconds"] ?? 0;
		parsedDateTime.time_scale = dateTimeStruct[$ "time_scale"] ?? 0;
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedDateTime;
}