function Quest(_quest_id, _name, _description, _icon, _type, _rewards, _steps) constructor
{
	quest_id = _quest_id;
	name = _name;
	description = _description;
	icon = _icon;
	type = _type;
	
	rewards = _rewards;
	steps = _steps;
	
	is_completed = false;
	is_reward_paid = false;
	
	static ToJSONStruct = function()
	{
		return {
			quest_id: quest_id,
			is_completed: is_completed,
			is_reward_paid: is_reward_paid,
		}
	}
	
	static Clone = function()
	{ 
		return new Quest(
			quest_id, name, description,
			icon, type, rewards, steps
		);
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