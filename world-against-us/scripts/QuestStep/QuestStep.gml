function QuestStep(_quest_step_id, _name, _description, _icon, _type, _completion_check_function) constructor
{
	quest_step_id = _quest_step_id;
	name = _name;
	description = _description;
	icon = _icon;
	type = _type;
	completion_check_function = _completion_check_function;
	
	static Clone = function()
	{ 
		return new QuestStep(
			name,
			steps_progress,
			description,
			icon,
			type,
			completion_check_function
		);
	}
	
	static OnDestroy = function()
	{
		// NO PROPERTIES TO DESTROY
	}
}