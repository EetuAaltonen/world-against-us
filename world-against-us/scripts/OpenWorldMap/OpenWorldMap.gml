function OpenWorldMap()
{	
	// OPEN MAP
	var guiState = new GUIState(
		GUI_STATE.WorldMap, undefined, undefined,
		[
			CreateWindowWorldMap(GAME_WINDOW.WorldMap, -1)
		],
		GUI_CHAIN_RULE.OverwriteAll,
		undefined, undefined
	);
	global.GUIStateHandlerRef.RequestGUIState(guiState);
}