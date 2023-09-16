function ParseJSONStructToDatabaseQuest(_jsonStruct)
{
	var parsedQuest = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedQuest;
		var questStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(questStruct) <= 0) return parsedQuest;
	
		var icon = GetSpriteByName(questStruct[$ "icon"] ?? undefined);
		var questSteps = ParseJSONStructToMap(questStruct[$ "steps"] ?? undefined, "quest_step_id", ParseJSONStructToDatabaseQuestStep);
		var rewards = ParseJSONStructToArray(questStruct[$ "rewards"] ?? undefined, ParseJSONStructToDatabaseQuestReward);
	
		parsedQuest = new Quest(
			questStruct[$ "quest_id"] ?? undefined,
			questStruct[$ "name"] ?? undefined,
			questStruct[$ "description"] ?? EMPTY_STRING,
			icon,
			questStruct[$ "type"] ?? undefined,
			questSteps,
			rewards
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedQuest;
}