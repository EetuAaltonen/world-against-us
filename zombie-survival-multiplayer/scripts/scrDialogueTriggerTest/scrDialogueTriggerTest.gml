function scrDialogueTriggerTest()
{
	global.WorldStateData[? WORLD_STATE_UNLOCK_WALKIE_TALKIE] = true;
	global.GUIStateHandlerRef.CloseCurrentGUIState();
	global.DialogueHandlerRef.ResetDialogue();
}