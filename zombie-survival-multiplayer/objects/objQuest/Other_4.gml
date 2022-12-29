// TODO: This is for debugging, a quest progress should appear when accepting a quest
if (ds_map_size(questHandler.questsProgress) <= 0)
{
	questHandler.FetchQuestsProgress();
}