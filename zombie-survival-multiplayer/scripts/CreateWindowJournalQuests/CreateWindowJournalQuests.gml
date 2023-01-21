function CreateWindowJournalQuest(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var questWindow = new GameWindow(
		GAME_WINDOW.Quests,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var questElements = ds_list_create();
	var questBackgroundSize = new Size(windowSize.w, 900);
	var questBackground = new WindowImage(
		"questBackground",
		new Vector2(
			windowSize.w * 0.5 - (questBackgroundSize.w * 0.5),
			windowSize.h * 0.5 - (questBackgroundSize.h * 0.5)
		),
		questBackgroundSize, undefined, sprJournal, 0, 1, 0
	);
	
	var questTitle = new WindowText(
		"QuestTitle",
		new Vector2(650, 140),
		undefined, undefined,
		"Quests", font_large_bold, fa_center, fa_middle, c_black, 1
		
	);
	
	var questListMap = new WindowListMap(
		"QuestListMap",
		new Vector2(330, 200), new Size(540, 600), undefined,
		global.QuestHandlerRef.questsProgress, ListDrawJournalQuest, true, OnClickListJournalQuest 
	);
	
	var questStepListArray = new WindowListArray(
		"QuestStepListArray",
		new Vector2(1030, 200), new Size(540, 600), undefined,
		[], ListDrawJournalQuestStep, true, function() { show_message(string(self)); }
	);
	
	ds_list_add(questElements,
		questBackground,
		questTitle,
		questListMap,
		questStepListArray
	);
	
	questWindow.AddChildElements(questElements);
	return questWindow;
}