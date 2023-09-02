function ParseJSONStructToDatabaseQuest(_jsonStruct)
{
	var quest = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return quest;
	
			var icon = GetSpriteByName(_jsonStruct[$ "icon"] ?? undefined);
			var questSteps = ParseJSONStructArrayToMap(_jsonStruct[$ "steps"] ?? undefined, "quest_step_id", ParseJSONStructToDatabaseQuestStep);
			var rewards = ParseJSONStructToArray(_jsonStruct[$ "rewards"] ?? undefined, ParseJSONStructToDatabaseQuestReward);
	
			quest = new Quest(
				_jsonStruct[$ "quest_id"],
				_jsonStruct[$ "name"],
				_jsonStruct[$ "description"],
				icon,
				_jsonStruct[$ "type"],
				questSteps,
				rewards
			);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	return quest;
}