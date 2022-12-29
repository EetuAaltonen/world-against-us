function QuestProgress(_quest_id, _steps_progress, _is_completed = false, _is_reward_paid = false) constructor
{
	quest_id = _quest_id;
	steps_progress = _steps_progress;
	
	is_completed = _is_completed;
	is_reward_paid = _is_reward_paid;
	
	static ToJSONStruct = function()
	{
		return {
			quest_id: quest_id,
			steps_progress: [], // TODO: Format quest steps
			is_completed: is_completed,
			is_reward_paid: is_reward_paid
		}
	}
	
	static Clone = function()
	{ 
		return new QuestProgress(quest_id, steps_progress, is_completed, is_reward_paid);
	}
}