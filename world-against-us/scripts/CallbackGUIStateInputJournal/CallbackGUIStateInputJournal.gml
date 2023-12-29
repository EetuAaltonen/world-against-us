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
				global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.JournalEntries, [
					CreateWindowJournal(GAME_WINDOW.JournalEntries, -1)
				], GUI_CHAIN_RULE.Overwrite);
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN QUESTS
				global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.JournalQuests, [
					CreateWindowJournalQuest(GAME_WINDOW.JournalQuests, -1)
				], GUI_CHAIN_RULE.Overwrite);
			}
		}
	}
}