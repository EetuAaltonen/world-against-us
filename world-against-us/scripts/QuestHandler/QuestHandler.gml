function QuestHandler() constructor
{
	questsProgress = ds_map_create();
	activeQuestIndex = undefined; // TODO: Set active quest
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(questsProgress, ds_type_map);
		questsProgress = undefined;
	}
}