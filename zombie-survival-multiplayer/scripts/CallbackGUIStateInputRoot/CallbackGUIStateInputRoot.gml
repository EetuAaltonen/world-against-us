function CallbackGUIStateInputRoot()
{
	if (room != roomMainMenu)
	{
		// DEFAULT IN GAME GUI KEYBINDINGS
		if (keyboard_check_released(KEY_ESC_MENU))
		{
			// OPEN	ESC MENU
			var guiState = new GUIState(
				GUI_STATE.EscMenu, undefined, undefined,
				[GAME_WINDOW.EscMenu], GUI_CHAIN_RULE.OverwriteAll
			);
			if (global.GUIStateHandlerRef.RequestGUIState(guiState))
			{
				global.GameWindowHandlerRef.OpenWindowGroup([
					CreateWindowEscMenu(-1)
				]);
			}
		} else if (keyboard_check_released(KEY_PLAYER_OVERVIEW))
		{
			// OPEN PLAYER BACKPACK
			var guiState = new GUIState(
				GUI_STATE.PlayerOverview, GUI_VIEW.PlayerBackpack, undefined,
				[GAME_WINDOW.PlayerBackpack], GUI_CHAIN_RULE.OverwriteAll,
				CallbackGUIStateInputPlayerOverview, KEY_PLAYER_OVERVIEW
			);
			if (global.GUIStateHandlerRef.RequestGUIState(guiState))
			{
				global.GameWindowHandlerRef.OpenWindowGroup([
					CreateWindowPlayerBackpack(-1)
				]);
			}
		} else if (keyboard_check_released(KEY_JOURNAL))
		{
			// OPEN JOURNAL
			var guiState = new GUIState(
				GUI_STATE.Journal, undefined, undefined,
				[GAME_WINDOW.JournalEntries], GUI_CHAIN_RULE.OverwriteAll,
				CallbackGUIStateInputJournal, KEY_JOURNAL
			);
			if (global.GUIStateHandlerRef.RequestGUIState(guiState))
			{
				global.GameWindowHandlerRef.OpenWindowGroup([
					CreateWindowJournal(-1)
				]);
			}
		} else if (keyboard_check_released(KEY_MAP))
		{
			// OPEN MAP
			var guiState = new GUIState(
				GUI_STATE.Map, undefined, undefined,
				[GAME_WINDOW.Map], GUI_CHAIN_RULE.OverwriteAll,
				undefined, KEY_MAP
			);
			if (global.GUIStateHandlerRef.RequestGUIState(guiState))
			{
				global.GameWindowHandlerRef.OpenWindowGroup([
					CreateWindowMap(-1)
				]);
				// RESET MAP UPDATE TIMER
				global.ObjMap.mapUpdateTimer = 0;
				
			}
		}
	}
}