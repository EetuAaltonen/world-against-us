function ParseJSONStructToQuestStepProgress(_jsonStruct)
{
	var questStepProgress = undefined;
	try
	{
		if (variable_struct_names_count(_jsonStruct) <= 0) return questStepProgress;
		
		questStepProgress = new QuestStepProgress(
			_jsonStruct[$ "quest_step_id"],
			bool(_jsonStruct[$ "is_completed"] ?? false)
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return questStepProgress;
}