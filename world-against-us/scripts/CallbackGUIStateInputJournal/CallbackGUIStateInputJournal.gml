function CallbackGUIStateInputJournal()
{
	if (room != roomMainMenu)
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		if (currentGUIState.index == GUI_STATE.Journal)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN JOURNAL
				if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.JournalEntries, [GAME_WINDOW.JournalEntries]))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowJournal(GAME_WINDOW.JournalEntries, -1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN QUESTS
				if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.JournalQuests, [GAME_WINDOW.JournalQuests]))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowJournalQuest(GAME_WINDOW.JournalQuests, -1)
					]);
				}
			}
		}
	}
}