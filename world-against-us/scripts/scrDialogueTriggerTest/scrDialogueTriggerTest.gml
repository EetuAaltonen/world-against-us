function scrDialogueTriggerTest()
{
	global.WorldStateData.SetWorldState(WORLD_STATE_UNLOCK_WALKIE_TALKIE, true);
	global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
	global.DialogueHandlerRef.ResetDialogue();
}