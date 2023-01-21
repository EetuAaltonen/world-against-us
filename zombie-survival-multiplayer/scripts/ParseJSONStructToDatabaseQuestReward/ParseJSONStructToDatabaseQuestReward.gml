function ParseJSONStructToDatabaseQuestReward(_jsonStruct)
{
	var questReward = undefined;
	if (!is_undefined(_jsonStruct))
	{
		try
		{
			if (variable_struct_names_count(_jsonStruct) <= 0) return questReward;
			
			questReward = new QuestReward(
				_jsonStruct[$ "type"],
				_jsonStruct[$ "reward_name"],
				_jsonStruct[$ "quantity"]
			);
		} catch (error)
		{
			show_debug_message(error);
		}
	}
	return questReward;
}