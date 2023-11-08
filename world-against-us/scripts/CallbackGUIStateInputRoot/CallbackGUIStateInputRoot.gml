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
					CreateWindowEscMenu(GAME_WINDOW.EscMenu, -1)
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
					CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1)
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
					CreateWindowJournal(GAME_WINDOW.JournalEntries, -1)
				]);
			}
		} else if (keyboard_check_released(KEY_MAP))
		{
			// LOAD STATIC MAP DATA
			var targetRoomName = room_get_name(room);
			var fileName = global.MapDataHandlerRef.GetMapDataFileName(targetRoomName);
			global.MapDataHandlerRef.ReadStaticMapDataFile(fileName);
			
			// OPEN MAP
			var guiState = new GUIState(
				GUI_STATE.Map, undefined, undefined,
				[GAME_WINDOW.Map], GUI_CHAIN_RULE.OverwriteAll,
				undefined, KEY_MAP
			);
			if (global.GUIStateHandlerRef.RequestGUIState(guiState))
			{
				global.GameWindowHandlerRef.OpenWindowGroup([
					CreateWindowMap(GAME_WINDOW.Map, -1)
				]);
			}
		} else if (keyboard_check_released(KEY_PLAYER_LIST))
		{
			if (global.MultiplayerMode)
			{
				// OPEN PLAYER LIST
				var guiState = new GUIState(
					GUI_STATE.PlayerList, undefined, undefined,
					[GAME_WINDOW.PlayerList], GUI_CHAIN_RULE.OverwriteAll,
					undefined, KEY_PLAYER_LIST
				);
				if (global.GUIStateHandlerRef.RequestGUIState(guiState))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowPlayerList(GAME_WINDOW.PlayerList, -1)
					]);
				
				}
			}
		}
	}
}