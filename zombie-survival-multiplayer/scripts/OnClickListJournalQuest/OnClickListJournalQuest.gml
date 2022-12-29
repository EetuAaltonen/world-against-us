function OnClickListJournalQuest(_questProgress)
{
	var allQuestsProgress = global.QuestHandlerRef.GetAllQuestsProgress();
	var questProgress = allQuestsProgress[? _questProgress.quest_id];
	
	questProgress.is_completed = !questProgress.is_completed;
	questProgress.is_reward_paid = !questProgress.is_reward_paid;
}