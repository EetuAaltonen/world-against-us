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
				if (global.GUIStateHandler.RequestGUIView(GUI_VIEW.JournalEntries, [GAME_WINDOW.JournalEntries]))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowJournal(-1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN QUESTS
				if (global.GUIStateHandler.RequestGUIView(GUI_VIEW.JournalQuests, [GAME_WINDOW.JournalQuests]))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowJournalQuest(-1)
					]);
				}
			}
		}
	}
}