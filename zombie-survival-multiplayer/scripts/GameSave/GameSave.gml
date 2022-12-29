function GameSave(_save_name) constructor
{
	save_name = _save_name;
	player = {
		inventory_items: [],
		magazine_pockets_items: [],
		medicine_pockets_items: [],
		quests_progress: []
	}
	
	static FetchSaveData = function()
	{
		// INVENTORY ITEMS
		var items = [];
		var itemCount = ds_list_size(global.PlayerBackpack.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerBackpack.items[| i];
			array_push(items, item.ToJSONStruct());
		}
		player.inventory_items = items;
		
		// MAGAZINE POCKETS ITEMS
		var items = [];
		var itemCount = ds_list_size(global.PlayerMagazinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMagazinePockets.items[| i];
			array_push(items, item.ToJSONStruct());
		}
		player.magazine_pockets_items = items;
		
		// MEDICINE POCKETS ITEMS
		var items = [];
		var itemCount = ds_list_size(global.PlayerMedicinePockets.items);
		for (var i = 0; i < itemCount; i++)
		{
			var item = global.PlayerMedicinePockets.items[| i];
			array_push(items, item.ToJSONStruct());
		}
		player.medicine_pockets_items = items;
		
		// QUESTS
		var quests_progress = [];
		var allQuestsProgress = global.QuestHandlerRef.GetAllQuestsProgress();
		var questIndices = ds_map_keys_to_array(allQuestsProgress);
		var questCount = array_length(questIndices);
		for (var i = 0; i < questCount; i++)
		{
			var questKey = questIndices[@ i];
			var questProgress = allQuestsProgress[? questKey];
			var questProgressStruct = {};
			variable_struct_set(questProgressStruct, questKey, questProgress.ToJSONStruct());
			// TODO: Save quest steps
			array_push(quests_progress, questProgressStruct);
		}
		player.quests_progress = quests_progress;
	}
	
	static ToJSONString = function()
	{
		var gameSaveStruct = {}
		variable_struct_set(gameSaveStruct, save_name, { "player": player });
		return json_stringify(gameSaveStruct);
	}
	
	static ParseGameSaveStruct = function(_gameSaveStruct)
	{
		var saveDataStruct = _gameSaveStruct[$ save_name];
		var playerDataStruct = saveDataStruct[$ "player"];
		
		// PARSE INVENTORY ITEMS
		var inventoryStruct = playerDataStruct[$ "inventory_items"];
		if (!is_undefined(inventoryStruct))
		{
			var itemCount = array_length(inventoryStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = inventoryStruct[@ i];
				var item = JSONStructToItem(itemStruct);
				global.PlayerBackpack.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE MAGAZINE POCKETS ITEMS
		var magazinePocketsStruct = playerDataStruct[$ "magazine_pockets_items"];
		if (!is_undefined(magazinePocketsStruct))
		{
			var itemCount = array_length(magazinePocketsStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = magazinePocketsStruct[@ i];
				var item = JSONStructToItem(itemStruct);
				global.PlayerMagazinePockets.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE MEDICINE POCKETS ITEMS
		var medicinePocketsStruct = playerDataStruct[$ "medicine_pockets_items"];
		if (!is_undefined(medicinePocketsStruct))
		{
			var itemCount = array_length(medicinePocketsStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = medicinePocketsStruct[@ i];
				var item = JSONStructToItem(itemStruct);
				global.PlayerMedicinePockets.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE QUESTS
		var questsStruct = playerDataStruct[$ "quests_progress"];
		if (!is_undefined(questsStruct))
		{
			var questCount = array_length(questsStruct);
			for (var i = 0; i < questCount; i++)
			{
				var questProgressStruct = questsStruct[@ i];
				var questId = variable_struct_get_names(questProgressStruct)[0];
				var questProgress = questProgressStruct[$ questId];
				// TODO: Parse quest steps progress
				ds_map_add(global.QuestHandlerRef.questsProgress, questId, new QuestProgress(
					questProgress.quest_id, questProgress.steps_progress,
					questProgress.is_completed, questProgress.is_reward_paid
				));
			}
		}
	}
}