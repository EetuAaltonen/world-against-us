function ParseJSONStructToQuestProgress(_jsonStruct)
{
	var parsedQuestProgress = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedQuestProgress;
		var questProgressStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(questProgressStruct) <= 0) return parsedQuestProgress;
		
		var questStepsProgress = ParseJSONStructToArray(questProgressStruct[$ "steps_progress"] ?? undefined, ParseJSONStructToQuestStepProgress);
		parsedQuestProgress = new QuestProgress(
			questProgressStruct[$ "quest_id"] ?? undefined,
			questStepsProgress,
			bool(questProgressStruct[$ "is_completed"] ?? false),
			bool(questProgressStruct[$ "is_reward_paid"] ?? false)
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedQuestProgress;
}