function Quest(_quest_id, _name, _description, _icon, _type, _steps, _rewards) constructor
{
	quest_id = _quest_id;
	name = _name;
	description = _description;
	icon = _icon;
	type = _type;
	steps = _steps;
	rewards = _rewards;
	
	static Clone = function()
	{ 
		return new Quest(
			quest_id,
			name, description,
			icon,
			type,
			steps,
			rewards
		);
	}
	
	static OnDestroy = function()
	{
		ClearDSMapAndDeleteValues(steps);
		ds_map_destroy(steps);
	}
	
	static CheckCompleted = function()
	{
		if (!is_completed)
		{
			is_completed = true;
		}
		return is_completed;
	}
	
	static PayReward = function()
	{
		if (!is_reward_paid)
		{
			is_reward_paid = true;
		}
	}
}