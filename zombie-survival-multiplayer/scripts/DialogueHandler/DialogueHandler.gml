function DialogueHandler() constructor
{
	dialogue_window = undefined;
	active_dialogue = undefined;
	active_character_icon = SPRITE_ERROR;
	
	static OpenDialogue = function(_dialogueStoryTitle, _dialogueIndex = undefined)
	{
		if (!is_undefined(global.DialogueData))
		{
			if (!is_undefined(global.DialogueData[? _dialogueStoryTitle]))
			{
				var dialogueIndex = !is_undefined(_dialogueIndex) ? _dialogueIndex : DIALOGUE_DEFAULT_INDEX;
				active_dialogue = global.DialogueData[? _dialogueStoryTitle][? dialogueIndex];
				
				// OPEN DIALOGUE
				var guiState = new GUIState(
					GUI_STATE.Dialogue, undefined, undefined,
					[GAME_WINDOW.Dialogue], GUI_CHAIN_RULE.OverwriteAll
				);
				if (global.GUIStateHandlerRef.RequestGUIState(guiState))
				{
					dialogue_window = CreateWindowDialogue(-1, active_character_icon);
					global.GameWindowHandlerRef.OpenWindowGroup([
						dialogue_window
					]);
					SetDialogue(active_dialogue);
				}
			}
		}
	}
	
	static SetDialogue = function(_newDialogue)
	{
		active_dialogue = _newDialogue;
		
		if (active_dialogue.chat != "")
		{
			if (!is_undefined(active_dialogue.character_icon))
			{
				active_character_icon =  active_dialogue.character_icon;
		
				var characterIcon = dialogue_window.GetChildElementById("characterIcon");
				characterIcon.spriteIndex = active_character_icon;
				characterIcon.initImage = true;
			}
		
			var chat = dialogue_window.GetChildElementById("chat");
			chat.text = active_dialogue.chat;
			var dialogueOptionCount = array_length(active_dialogue.dialogue_options);
			var dialogueOptionButtons = ds_list_create();
			for (var i = 0; i < dialogueOptionCount; i++)
			{
				var dialogueOption = active_dialogue.dialogue_options[@ i];
				var optionButton = {
					title: dialogueOption.chat, onClick: OnClickDialogueOption,
					metadata: { dialogueOption: dialogueOption }
				};
			
				ds_list_add(dialogueOptionButtons, optionButton);
			}
			var dialogueOptionMenu = dialogue_window.GetChildElementById("options");
			dialogueOptionMenu.buttonsData = dialogueOptionButtons;
			dialogueOptionMenu.initButtons = true;
		} else {
			if (!is_undefined(active_dialogue.trigger_function))
			{
				script_execute(active_dialogue.trigger_function);
			}
		}
	}
	
	static ResetDialogue = function()
	{
		dialogue_window = undefined;
		active_dialogue = undefined;
		active_character_icon = SPRITE_ERROR;
	}
}