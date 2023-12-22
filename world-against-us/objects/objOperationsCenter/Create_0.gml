// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Open monitor";
interactionFunction = function()
{	
	// OPEN OPERATIONS CENTER
	var guiState = new GUIState(
		GUI_STATE.Facility, undefined, undefined,
		[GAME_WINDOW.OperationsCenter], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowOperationsCenter(GAME_WINDOW.OperationsCenter, -1)
		]);
	}
}