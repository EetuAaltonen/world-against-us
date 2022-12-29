function QuestStepProgress(_quest_step_id, _is_completed = false, _is_reward_paid = false) constructor
{
	quest_step_id = _quest_step_id;
	
	is_completed = _is_completed;
	is_reward_paid = _is_reward_paid;
	
	static ToJSONStruct = function()
	{
		return {
			quest_step_id: quest_step_id,
			// TODO: Format quest steps
			is_completed: is_completed,
			is_reward_paid: is_reward_paid
		}
	}
	
	static Clone = function()
	{ 
		return new QuestStepProgress(quest_step_id, is_completed, is_reward_paid);
	}
}