if (global.GUIStateHandler.IsGUIStateClosed())
{
	if (room != roomMainMenu)
	{
		if (keyboard_check_released(ord("M")))
		{
			// OPEN PLAYER BACKPACK
			var guiState = new GUIState(
				GUI_STATE.Map, undefined, undefined,
				[GAME_WINDOW.Map], GUI_CHAIN_RULE.OverwriteAll
			);
			if (global.GUIStateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
					CreateWindowMap(-1)
				]);
				
				mapUpdateTimer = 0;
			}
		}
	}
}