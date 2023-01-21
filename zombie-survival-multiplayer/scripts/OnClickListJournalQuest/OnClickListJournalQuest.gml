function OnClickListJournalQuest(_questProgress)
{
	var questStepList = parentWindow.GetChildElementById("QuestStepListArray");
	if (!is_undefined(questStepList))
	{
		var quest = global.QuestData[? _questProgress.quest_id];
	
		var questStepProgressData = [];
		var questStepProgressCount = array_length(_questProgress.steps_progress);
		for (var i = 0; i < questStepProgressCount; i++)
		{
			var questStepProgress = _questProgress.steps_progress[@ i];
			array_push(questStepProgressData, {
				database_quest_step: quest.steps[? questStepProgress.quest_step_id],
				is_completed: questStepProgress.is_completed
			});
		}
		
		questStepList.listData = questStepProgressData;
		questStepList.initListElements = true;
	}
}