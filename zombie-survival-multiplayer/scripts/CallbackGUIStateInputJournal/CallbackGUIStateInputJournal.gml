function CallbackGUIStateInputJournal()
{
	if (room != roomMainMenu)
	{
		var currentGUIState = global.GUIStateHandler.GetGUIState();
		if (currentGUIState.index == GUI_STATE.Journal)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN JOURNAL
				var guiState = new GUIState(
					currentGUIState.index, undefined, undefined,
					[GAME_WINDOW.Journal], GUI_CHAIN_RULE.OverwriteAll,
					CallbackGUIStateInputJournal, KEY_JOURNAL
				);
				if (global.GUIStateHandler.RequestGUIState(guiState))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowJournal(-1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN QUESTS
				var guiState = new GUIState(
					currentGUIState.index, GUI_VIEW.Quests, undefined,
					[GAME_WINDOW.Quests], GUI_CHAIN_RULE.OverwriteAll,
					CallbackGUIStateInputJournal, KEY_JOURNAL
				);
				if (global.GUIStateHandler.RequestGUIState(guiState))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowJournalQuest(-1)
					]);
				}
			}
		}
	}
}