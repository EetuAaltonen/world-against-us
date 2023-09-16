function ParseJSONStructToDatabaseQuestReward(_jsonStruct)
{
	var parsedQuestReward = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedQuestReward;
		var questRewardStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(questRewardStruct) <= 0) return parsedQuestReward;
			
		parsedQuestReward = new QuestReward(
			questRewardStruct[$ "type"] ?? undefined,
			questRewardStruct[$ "reward_name"] ?? undefined,
			questRewardStruct[$ "quantity"] ?? 1
		);
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedQuestReward;
}