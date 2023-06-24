if (stateHandler.IsGUIStateClosed())
{
	if (room != roomMainMenu)
	{
		// DEFAULT GUI KEYBINDINGS
		if (keyboard_check_released(KEY_ESC_MENU))
		{
			// OPEN	ESC MENU
			var guiState = new GUIState(
				GUI_STATE.EscMenu, undefined, undefined,
				[GAME_WINDOW.EscMenu], GUI_CHAIN_RULE.OverwriteAll
			);
			if (stateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
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
			if (stateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
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
			if (stateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
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
			if (stateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
					CreateWindowMap(-1)
				]);
				// RESET MAP UPDATE TIMER
				global.ObjMap.mapUpdateTimer = 0;
				
			}
		}
	}
} else {
	// CHECK CURRENT GUI STATE KEYBINDINGS
	stateHandler.CheckKeyboardInputGUIState();
}