function OpenWorldMap()
{	
	// OPEN MAP
	var guiState = new GUIState(
		GUI_STATE.WorldMap, undefined, undefined,
		[GAME_WINDOW.WorldMap], GUI_CHAIN_RULE.OverwriteAll,
		undefined, undefined
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowWorldMap(GAME_WINDOW.WorldMap, -1)
		]);
	}
}