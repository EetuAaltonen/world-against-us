function ParseJSONStructToQuestProgress(_jsonStruct)
{
	var questProgress = undefined;
	try
	{
		if (variable_struct_names_count(_jsonStruct) <= 0) return questProgress;
		
		var questStepsProgress = ParseJSONStructToArray(_jsonStruct[$ "steps_progress"], ParseJSONStructToQuestStepProgress)
		questProgress = new QuestProgress(
			_jsonStruct[$ "quest_id"],
			questStepsProgress,
			bool(_jsonStruct[$ "is_completed"] ?? false),
			bool(_jsonStruct[$ "is_reward_paid"] ?? false)
		);
	} catch (error)
	{
		show_debug_message(error);
	}
	return questProgress;
}