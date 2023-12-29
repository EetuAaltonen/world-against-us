// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Open monitor";
interactionFunction = function()
{	
	// OPEN OPERATIONS CENTER
	var guiState = new GUIState(
		GUI_STATE.Facility, undefined, undefined,
		[
			CreateWindowOperationsCenter(GAME_WINDOW.OperationsCenter, -1)
		],
		GUI_CHAIN_RULE.OverwriteAll
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
}