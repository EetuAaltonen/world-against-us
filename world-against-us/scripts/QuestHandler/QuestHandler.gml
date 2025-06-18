function QuestHandler() constructor
{
	questsProgress = ds_map_create();
	activeQuestIndex = undefined; // TODO: Set active quest
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.questsProgress, ds_type_map);
		_struct.questsProgress = undefined;
	}
}