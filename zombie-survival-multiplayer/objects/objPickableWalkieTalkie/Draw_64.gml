// INHERIT THE PARENT EVENT
event_inherited();

if (!is_undefined(global.DialogueData))
{
	if (global.GUIStateHandlerRef.IsGUIStateClosed())
	{
		if (overheadDialogueTimer.GetTime() >= floor(overheadDialogueTimer.GetSettingTime() * 0.25))
		{
			var text = global.DialogueData[? dialogueStoryTitle][? overheadDialogueIndex].chat ?? "Error";
			var textColor = c_white;
			var positionOnGUI = PositionToGUI(new Vector2(x, y - 50));
			draw_text_color(positionOnGUI.X, positionOnGUI.Y, text, textColor, textColor, textColor, textColor, 1);
		}
	}
}