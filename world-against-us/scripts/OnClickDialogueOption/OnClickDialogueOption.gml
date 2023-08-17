function OnClickDialogueOption()
{
	if (!is_undefined(metadata))
	{
		var nextDialogueIndex = metadata.dialogueOption.GetNextIndex();
		var nextDialogue = global.DialogueData[? metadata.dialogueOption.parent_story_title][? nextDialogueIndex];
		global.DialogueHandlerRef.SetDialogue(nextDialogue);
	}
}