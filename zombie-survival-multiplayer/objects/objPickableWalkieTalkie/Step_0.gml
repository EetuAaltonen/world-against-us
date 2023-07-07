if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	overheadDialogueTimer.Update();
	
	if (overheadDialogueTimer.IsTimerStopped())
	{
		var currentDialogue = global.DialogueData[? dialogueStoryTitle][? overheadDialogueIndex];
		if (!is_undefined(currentDialogue))
		{
			overheadDialogueIndex = currentDialogue.GetFirstOption().GetNextIndex();
		}
		overheadDialogueTimer.StartTimer();
	}
}