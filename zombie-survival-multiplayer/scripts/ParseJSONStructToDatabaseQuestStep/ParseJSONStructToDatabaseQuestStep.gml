function ParseJSONStructToDatabaseQuestStep(_jsonStruct)
{
	var questStep = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return questStep;
			
			var icon = GetSpriteByName(_jsonStruct[$ "icon"]);
			var completionCheckFunction =  GetScriptByName(_jsonStruct[$ "completion_check_function_name"]);
			
			questStep = new QuestStep(
				_jsonStruct[$ "quest_step_id"],
				_jsonStruct[$ "name"],
				_jsonStruct[$ "description"],
				icon,
				_jsonStruct[$ "type"],
				completionCheckFunction
			);
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return questStep;
}