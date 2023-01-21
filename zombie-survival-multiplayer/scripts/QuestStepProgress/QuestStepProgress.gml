function QuestStepProgress(_quest_step_id, _is_completed = false) constructor
{
	quest_step_id = _quest_step_id;
	is_completed = _is_completed;
	
	static ToJSONStruct = function()
	{
		return {
			quest_step_id: quest_step_id,
			is_completed: is_completed
		}
	}
	
	static Clone = function()
	{
		return new QuestStepProgress(
			quest_step_id,
			is_completed
		);
	}
}