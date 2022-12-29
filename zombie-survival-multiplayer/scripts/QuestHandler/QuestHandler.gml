function QuestHandler() constructor
{
	questsProgress = ds_map_create();
	activeQuestIndex = undefined; // TODO: Set active quest
	
	static FetchQuestsProgress = function()
	{
		ds_map_clear(questsProgress);
		var questIndices = ds_map_keys_to_array(global.QuestData);
		var questCount = array_length(questIndices);
		for (var i = 0; i < questCount; i++)
		{
			var questId = questIndices[@ i];
			var quest = global.QuestData[? questId];
			ds_map_add(questsProgress, questId, new QuestProgress(
				questId, quest.steps, false, false
			));
		}
	}
	
	static GetQuestProgressByIndex = function(_questIndex)
	{
		return questsProgress[? _questIndex];
	}
	
	static GetAllQuestsProgress = function()
	{
		return questsProgress;
	}
}