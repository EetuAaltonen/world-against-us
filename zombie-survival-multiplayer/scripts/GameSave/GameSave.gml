function GameSave(_save_name) constructor
{
	save_name = _save_name;
	player = {
		backpack_items: [],
		magazine_pockets_items: [],
		medicine_pockets_items: [],
		quests_progress: []
	}
	
	world = {
		rooms: []
	}
	
	static ToJSONStruct = function()
	{
		var gameSaveStruct = {}
		variable_struct_set(gameSaveStruct, save_name, {
			player: player,
			world: world,
		});
		return gameSaveStruct;
	}
	
	static FetchSaveData = function()
	{
		// PLAYER - BACKPACK ITEMS
		player.backpack_items = global.PlayerBackpack.ToJSONStruct().items;
		
		// PLAYER - MAGAZINE POCKETS ITEMS
		player.magazine_pockets_items = global.PlayerMagazinePockets.ToJSONStruct().items;
		
		// PLAYER - MEDICINE POCKETS ITEMS
		player.medicine_pockets_items = global.PlayerMedicinePockets.ToJSONStruct().items;
		
		// PLAYER - QUESTS
		var quests_progress = [];
		var questIndices = ds_map_keys_to_array(global.QuestHandlerRef.questsProgress);
		var questCount = array_length(questIndices);
		for (var i = 0; i < questCount; i++)
		{
			var questKey = questIndices[@ i];
			var questProgress = global.QuestHandlerRef.questsProgress[? questKey];
			array_push(quests_progress, questProgress.ToJSONStruct());
		}
		player.quests_progress = quests_progress;
		
		// WORLD - FACILITIES
		var roomName = room_get_name(room);
		var roomData = new RoomData(roomName);
		array_push(
			world.rooms,
			roomData.ToJSONStruct()
		);
	}
	
	static ParseGameSavePlayerDataStruct = function(_gameSaveStruct)
	{
		var saveDataStruct = _gameSaveStruct[$ save_name];
		var playerDataStruct = saveDataStruct[$ "player"];
		
		// PARSE INVENTORY ITEMS
		var inventoryStruct = playerDataStruct[$ "backpack_items"];
		if (!is_undefined(inventoryStruct))
		{
			// CLEAR BACKPACK
			global.PlayerBackpack.ClearItems();
			// ADD NEW ITEMS
			var itemCount = array_length(inventoryStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = inventoryStruct[@ i];
				var item = ParseJSONStructToItem(itemStruct);
				global.PlayerBackpack.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE MAGAZINE POCKETS ITEMS
		var magazinePocketsStruct = playerDataStruct[$ "magazine_pockets_items"];
		if (!is_undefined(magazinePocketsStruct))
		{
			// CLEAR MAGAZINE POCKETS
			global.PlayerMagazinePockets.ClearItems();
			// ADD NEW ITEMS
			var itemCount = array_length(magazinePocketsStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = magazinePocketsStruct[@ i];
				var item = ParseJSONStructToItem(itemStruct);
				global.PlayerMagazinePockets.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE MEDICINE POCKETS ITEMS
		var medicinePocketsStruct = playerDataStruct[$ "medicine_pockets_items"];
		if (!is_undefined(medicinePocketsStruct))
		{
			// CLEAR MEDICINE POCKETS
			global.PlayerMedicinePockets.ClearItems();
			// ADD NEW ITEMS
			var itemCount = array_length(medicinePocketsStruct);
			for (var i = 0; i < itemCount; i++)
			{
				var itemStruct = medicinePocketsStruct[@ i];
				var item = ParseJSONStructToItem(itemStruct);
				global.PlayerMedicinePockets.AddItem(item, item.grid_index, item.known, true);
			}
		}
		
		// PARSE QUESTS
		var questsStruct = playerDataStruct[$ "quests_progress"];
		if (!is_undefined(questsStruct))
		{
			var questsProgressMap = ParseJSONStructArrayToMap(questsStruct, "quest_id", ParseJSONStructToQuestProgress);
			global.QuestHandlerRef.questsProgress = questsProgressMap;
		}
	}
	
	static ParseGameSaveRoomDataStruct = function(_gameSaveStruct)
	{
		// PARSE WORLD ROOMS
		var saveDataStruct = _gameSaveStruct[$ save_name];
		var worldDataStruct = saveDataStruct[$ "world"];
		if (!is_undefined(worldDataStruct))
		{
			var roomsDataStruct = worldDataStruct[$ "rooms"];
			if (!is_undefined(roomsDataStruct))
			{
				var roomCount = array_length(roomsDataStruct);
				for (var i = 0; i < roomCount; i++)
				{
					var roomDataStruct = roomsDataStruct[@ i];
					var roomName = variable_struct_get_names(roomDataStruct)[0];
					if (room_get_name(room) = roomName)
					{
						var roomData = roomDataStruct[$ roomName];
						var facilityCount = array_length(roomData.facilities);
						for (var j = 0; j < facilityCount; j++)
						{
							var facilityStruct = roomData.facilities[j];
							var facility = ParseJSONStructToFacility(facilityStruct);
							var inventoryStruct = facilityStruct[$ "inventory"] ?? undefined;
							var itemArray = (!is_undefined(inventoryStruct)) ? ParseJSONStructToArray(inventoryStruct[$ "items"], ParseJSONStructToItem) : [];
							var instanceCount = instance_number(objFacilityParent);
							for (var k = 0; k < instanceCount; k++)
							{
								var instance = instance_find(objFacilityParent, k);
								if (instance_exists(instance))
								{
									if (instance.facilityId == facility.facility_id)
									{
										if (!is_undefined(instance.facility))
										{
											instance.facility.metadata = facility.metadata;
											if (!is_undefined(instance.facility.inventory))
											{
												// CLEAR FACILITY INVENTORY
												instance.facility.inventory.ClearItems();
												// ADD NEW ITEMS
												var itemCount = array_length(itemArray);
												for (var l = 0; l < itemCount; l++)
												{
													var item = itemArray[l];
													instance.facility.inventory.AddItem(item, item.grid_index, item.known);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}