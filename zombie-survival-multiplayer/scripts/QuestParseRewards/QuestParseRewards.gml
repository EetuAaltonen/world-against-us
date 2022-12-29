function QuestParseRewards(_rewards)
{
	var questRewards = [];
	var rewardsCount = array_length(_rewards);
	for (var i = 0; i < rewardsCount; i++)
	{
		var reward = _rewards[@ i];
		array_push(questRewards, new QuestReward(
			reward[$ "type"],
			reward[$ "reward"],
			reward[$ "amount"]
		));
	}
	return questRewards;
}