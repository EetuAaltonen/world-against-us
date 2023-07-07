function DialogueOption(_parent_story_title, _parent_dialogue_id, _chat, _next_dialogue_id) constructor
{
	parent_story_title = _parent_story_title;
	parent_dialogue_id = _parent_dialogue_id;
	chat = _chat;
	next_dialogue_id = _next_dialogue_id;
	
	static Clone = function()
	{
		return new DialogueOption(
			parent_story_title,
			parent_dialogue_id,
			chat,
			next_dialogue_id
		);
	}
	
	static GetNextIndex = function()
	{
		return next_dialogue_id;
	}
}