function Dialogue(_dialogue_story_title, _dialogue_index) constructor
{
	dialogue_story_title = _dialogue_story_title;
	dialogue_index = _dialogue_index;
	character_icon = undefined;
	chat = "";
	dialogue_options = [];
	trigger_function = undefined;
	
	static Clone = function()
	{
		return new Dialogue(
			dialogue_story_title,
			dialogue_index
		);
	}
	
	static AddChatLine = function(_chat_line)
	{
		chat += _chat_line;
	}
	
	static AddDialogueOption = function(_dialogue_option)
	{
		array_push(dialogue_options, _dialogue_option);
	}
	
	static GetFirstOption = function()
	{
		return array_first(dialogue_options);
	}
}