function ParseJSONStructToDatabaseQuestStep(_jsonStruct)
{
	var parsedQuestStep = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedQuestStep;
		var questStepStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(questStepStruct) <= 0) return parsedQuestStep;
			
		var icon = GetSpriteByName(questStepStruct[$ "icon"] ?? undefined);
		var completionCheckFunction = GetScriptByName(questStepStruct[$ "completion_check_function_name"] ?? undefined);
			
		parsedQuestStep = new QuestStep(
			questStepStruct[$ "quest_step_id"] ?? undefined,
			questStepStruct[$ "name"] ?? EMPTY_STRING,
			questStepStruct[$ "description"] ?? EMPTY_STRING,
			icon,
			questStepStruct[$ "type"] ?? undefined,
			completionCheckFunction
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedQuestStep;
}