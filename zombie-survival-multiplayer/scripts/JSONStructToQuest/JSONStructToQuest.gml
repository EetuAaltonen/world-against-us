function JSONStructToQuest(_jsonStruct)
{
	var questData = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
	if (variable_struct_names_count(questData) <= 0) return undefined;
	
	var icon = GetSpriteByIndex(questData[$ "icon"]);
	// PARSE REWARD
	var rewards = QuestParseRewards(questData[$ "rewards"]);
	
	return new Quest(
		questData[$ "quest_id"],
		questData[$ "name"],
		questData[$ "description"],
		icon,
		questData[$ "type"],
		rewards,
		[] // TODO: Parse quest steps
	);
}
