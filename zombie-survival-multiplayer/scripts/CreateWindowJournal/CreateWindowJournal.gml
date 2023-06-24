function CreateWindowJournal(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var journalWindow = new GameWindow(
		GAME_WINDOW.JournalEntries,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var journalElements = ds_list_create();
	var journalBackgroundSize = new Size(windowSize.w, 900);
	var journalBackground = new WindowImage(
		"journalBackground",
		new Vector2(
			windowSize.w * 0.5 - (journalBackgroundSize.w * 0.5),
			windowSize.h * 0.5 - (journalBackgroundSize.h * 0.5)
		),
		journalBackgroundSize, undefined, sprJournal, 0, 1, 0
	);
	
	var journalTitle = new WindowText(
		"JournalTitle",
		new Vector2(650, 140),
		undefined, undefined,
		"Journal", font_large_bold, fa_center, fa_middle, c_black, 1
		
	);
	
	var journalEntryList = new WindowList(
		"JournalEntryList",
		new Vector2(400, 200), new Size(470, 600), undefined,
		global.ObjJournal.journalEntries, ListDrawJournalEntry, false
	);
	
	ds_list_add(journalElements,
		journalBackground,
		journalTitle,
		journalEntryList
	);
	
	journalWindow.AddChildElements(journalElements);
	return journalWindow;
}