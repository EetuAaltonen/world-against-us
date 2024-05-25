function scrDialogueTriggerTest()
{
	global.WorldStateData.SetWorldStateProperty(WORLD_STATE_UNLOCK_WALKIE_TALKIE, true);
	global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
	global.DialogueHandlerRef.ResetDialogue();
}