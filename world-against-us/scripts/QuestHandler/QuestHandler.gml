function QuestHandler() constructor
{
	questsProgress = ds_map_create();
	activeQuestIndex = undefined; // TODO: Set active quest
	
	static OnDestroy = function()
	{
		ClearDSMapAndDeleteValues(questsProgress);
		ds_map_destroy(questsProgress);
	}
}