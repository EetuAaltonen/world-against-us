if (!is_undefined(global.WorldStateData))
{
	if (global.WorldStateData[? WORLD_STATE_UNLOCK_WALKIE_TALKIE]) instance_destroy();
}

if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (overheadDialogueTimer.IsTimerStopped())
	{
		var currentDialogue = global.DialogueData[? dialogueStoryTitle][? overheadDialogueIndex];
		if (!is_undefined(currentDialogue))
		{
			overheadDialogueIndex = currentDialogue.GetFirstOption().GetNextIndex();
		}
		overheadDialogueTimer.StartTimer();
	} else {
		overheadDialogueTimer.Update();
	}
}