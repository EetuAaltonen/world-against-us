function ParseJSONStructToQuestStepProgress(_jsonStruct)
{
	var parsedQuestStepProgress = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedQuestStepProgress;
		var questStepProgressStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(questStepProgressStruct) <= 0) return parsedQuestStepProgress;
		
		parsedQuestStepProgress = new QuestStepProgress(
			questStepProgressStruct[$ "quest_step_id"] ?? undefined,
			bool(questStepProgressStruct[$ "is_completed"] ?? false)
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedQuestStepProgress;
}