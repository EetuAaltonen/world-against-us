// INHERIT THE PARENT EVENT
event_inherited();

dialogueStoryTitle = "walkie_talkie_dialogue";
overheadDialogueIndex = "prologue_overhead1";

overheadDialogueTimer = new Timer(TimerFromSeconds(5));
overheadDialogueTimer.StartTimer();

interactionFunction = function()
{
	// OPEN DIALOGUE
	global.DialogueHandlerRef.OpenDialogue("walkie_talkie_dialogue", undefined);
}