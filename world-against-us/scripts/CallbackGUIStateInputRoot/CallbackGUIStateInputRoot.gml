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
				[
					CreateWindowEscMenu(GAME_WINDOW.EscMenu, -1)
				],
				GUI_CHAIN_RULE.OverwriteAll
			);
			global.GUIStateHandlerRef.RequestGUIState(guiState);
		} else if (keyboard_check_released(KEY_PLAYER_OVERVIEW))
		{
			// OPEN PLAYER BACKPACK
			var guiState = new GUIState(
				GUI_STATE.PlayerOverview, GUI_VIEW.PlayerBackpack, undefined,
				[
					CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1)
				],
				GUI_CHAIN_RULE.OverwriteAll,
				CallbackGUIStateInputPlayerOverview, KEY_PLAYER_OVERVIEW
			);
			global.GUIStateHandlerRef.RequestGUIState(guiState);
		} else if (keyboard_check_released(KEY_JOURNAL))
		{
			// OPEN JOURNAL
			var guiState = new GUIState(
				GUI_STATE.Journal, undefined, undefined,
				[
					CreateWindowJournal(GAME_WINDOW.JournalEntries, -1)
				],
				GUI_CHAIN_RULE.OverwriteAll,
				CallbackGUIStateInputJournal, KEY_JOURNAL
			);
			global.GUIStateHandlerRef.RequestGUIState(guiState);
		} else if (keyboard_check_released(KEY_MAP))
		{
			// TODO: Disable while prototyping
			/*// LOAD STATIC MAP DATA
			var targetRoomName = room_get_name(room);
			var fileName = global.MapDataHandlerRef.GetMapDataFileName(targetRoomName);
			global.MapDataHandlerRef.ReadStaticMapDataFile(fileName);
			
			// OPEN MAP
			var guiState = new GUIState(
				GUI_STATE.Map, undefined, undefined,
				[
					CreateWindowMap(GAME_WINDOW.Map, -1)
				],
				GUI_CHAIN_RULE.OverwriteAll,
				undefined, KEY_MAP
			);
			global.GUIStateHandlerRef.RequestGUIState(guiState)*/
		} else if (keyboard_check_released(KEY_PLAYER_LIST))
		{
			if (global.MultiplayerMode)
			{
				// OPEN PLAYER LIST
				var guiState = new GUIState(
					GUI_STATE.PlayerList, undefined, undefined,
					[
						CreateWindowPlayerList(GAME_WINDOW.PlayerList, -1)
					],
					GUI_CHAIN_RULE.OverwriteAll,
					undefined, KEY_PLAYER_LIST
				);
				global.GUIStateHandlerRef.RequestGUIState(guiState);
			}
		}
	}
}