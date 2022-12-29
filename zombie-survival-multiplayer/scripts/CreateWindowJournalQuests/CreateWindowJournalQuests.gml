function CreateWindowJournalQuest(_zIndex, _drawListFunction, _listElementCallbackFunction)
{
	var windowSize = new Size(global.GUIW, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var questWindow = new GameWindow(
		GAME_WINDOW.Quests,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var questElements = ds_list_create();
	var questBackgroundSize = new Size(windowSize.w, 800);
	var questBackground = new WindowImage(
		"questBackground",
		new Vector2(
			windowSize.w * 0.5 - (questBackgroundSize.w * 0.5),
			windowSize.h * 0.5 - (questBackgroundSize.h * 0.5)
		),
		questBackgroundSize, undefined, sprJournal
	);
	
	var questTitle = new WindowText(
		"QuestTitle",
		new Vector2(650, 140),
		undefined, undefined,
		"Quests", font_large_bold, fa_center, fa_middle, c_black, 1
		
	);
	
	var allQuests = global.QuestHandlerRef.GetAllQuestsProgress();
	var questListMap = new WindowListMap(
		"QuestListMap",
		new Vector2(400, 200), new Size(470, 600), undefined,
		allQuests, _drawListFunction, true, _listElementCallbackFunction 
	);
	
	ds_list_add(questElements,
		questBackground,
		questTitle,
		questListMap
	);
	
	questWindow.AddChildElements(questElements);
	return questWindow;
}