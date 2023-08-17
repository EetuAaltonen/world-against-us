function GameSave(_save_name) constructor
{
	save_name = FormatSaveName(_save_name);
	save_file_name = ConcatSaveFileSuffix(save_name);
	player_data = undefined;
	room_data = undefined;
	
	ResetSavePlayerData();
	ResetSaveRoomData();
	isSaveLoadingFirstTime = true;
	
	static ToJSONStruct = function()
	{
		var formatRoomName = room_get_name(player_data.last_location.room_index);
		var formatPosition = player_data.last_location.position.ToJSONStruct();
		var formatBackpack = player_data.inventory.backpack.ToJSONStruct();
		var formatMagazinePockets = player_data.inventory.magazine_pockets.ToJSONStruct();
		var formatMedicinePockets = player_data.inventory.medicine_pockets.ToJSONStruct();
		
		return {
			player_data: {
				last_location:
				{
					room_name: formatRoomName,
					position: formatPosition
				},
				inventory:
				{
					backpack: formatBackpack,
					magazine_pockets: formatMagazinePockets,
					medicine_pockets: formatMedicinePockets
				}
			} 
		}
	}
	
	static RoomToJSONStruct = function()
	{
		var formatRoomName = room_get_name(room);
		return {
			room_data: {
				name: formatRoomName,
				containers: room_data.containers
			} 
		}
	}
	
	static FetchSaveData = function()
	{
		var isSaveDataFetched = false;
		
		if (!is_undefined(save_name))
		{
			// PLAYER DATA
			if (!is_undefined(player_data))
			{
				player_data.last_location.room_index = room;
				var scaledPosition = ScaleFloatValuesToIntVector2(
					global.InstancePlayer.x,
					global.InstancePlayer.y
				);
				player_data.last_location.position = scaledPosition;
				player_data.inventory.backpack = global.PlayerBackpack;
				player_data.inventory.magazine_pockets = global.PlayerMagazinePockets;
				player_data.inventory.medicine_pockets = global.PlayerMedicinePockets;
				
				// ROOM DATA
				if (!is_undefined(room_data))
				{
					room_data.index = room;
					
					// CONTAINERS
					var containerInstanceCount = instance_number(objContainerParent);
					for (var i = 0; i < containerInstanceCount; i++)
					{
						var containerInstance = instance_find(objContainerParent, i);
						if (instance_exists(containerInstance))
						{
							if (containerInstance.isContainerSearched)
							{
								var formatInventory = (!is_undefined(containerInstance.inventory)) ? containerInstance.inventory.ToJSONStruct() : undefined;
								var containerStruct = {
									container_id: containerInstance.containerId,
									inventory: formatInventory
								}
								array_push(room_data.containers, containerStruct);
							}
						}
					}
					
					isSaveDataFetched = true;	
				}
			}
		}
		
		return isSaveDataFetched;
	}
	
	static ResetSavePlayerData = function()
	{
		player_data = {
			last_location:
			{
				room_index: undefined,
				position: undefined
			},
			inventory:
			{
				backpack: undefined,
				magazine_pockets: undefined,
				medicine_pockets: undefined
			}
		}
	}
	
	static ResetSaveRoomData = function()
	{
		room_data = {
			index: undefined,
			containers: []
		}
	}
	
	static ParseGameSaveStruct = function(_gameSaveStruct)
	{
		var isSaveLoaded = false;
		try
		{
			var playerDataStruct = _gameSaveStruct[$ "player_data"] ?? undefined;
			if (!is_undefined(playerDataStruct))
			{
				var lastLocationStruct = playerDataStruct[$ "last_location"] ?? undefined;
				if (!is_undefined(lastLocationStruct))
				{
					var roomName = lastLocationStruct[$ "room_name"] ?? undefined;
					if (!is_undefined(roomName))
					{
						var roomIndex = asset_get_index(roomName);
						player_data.last_location.room_index = (room_exists(roomIndex)) ? roomIndex : undefined;
						
						var positionStruct = lastLocationStruct[$ "position"] ?? undefined;
						if (!is_undefined(positionStruct))
						{
							var scaledPosition = ScaleIntValuesToFloatVector2(
								positionStruct[$ "X"],
								positionStruct[$ "Y"]
							);
							player_data.last_location.position = scaledPosition;
						}
					}
				}
				
				var inventoryStruct = playerDataStruct[$ "inventory"] ?? undefined;
				if (!is_undefined(inventoryStruct))
				{
					var backpackInventoryStruct = inventoryStruct[$ "backpack"] ?? undefined;
					if (!is_undefined(backpackInventoryStruct))
					{
						player_data.inventory.backpack = ParseJSONStructToInventory(backpackInventoryStruct);
					}
					
					var ammoInventoryStruct = inventoryStruct[$ "magazine_pockets"] ?? undefined;
					if (!is_undefined(ammoInventoryStruct))
					{
						player_data.inventory.magazine_pockets = ParseJSONStructToInventory(ammoInventoryStruct);
					}
					
					var medicineInventoryStruct = inventoryStruct[$ "medicine_pockets"] ?? undefined;
					if (!is_undefined(medicineInventoryStruct))
					{
						player_data.inventory.medicine_pockets = ParseJSONStructToInventory(medicineInventoryStruct);
					}
				}
			}
			
			isSaveLoadingFirstTime = true;
			isSaveLoaded = true;
			
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		
		return isSaveLoaded;
	}
	
	static ParseGameSaveRoomStruct = function(_gameSaveRoomStruct)
	{
		var isSaveLoaded = false;
		try
		{
			var roomDataStruct = _gameSaveRoomStruct[$ "room_data"] ?? undefined;
			if (!is_undefined(roomDataStruct))
			{
				var containers = roomDataStruct[$ "containers"] ?? undefined;
				if (!is_undefined(containers))
				{
					var containerCount = array_length(containers);
					for (var i = 0; i < containerCount; i++)
					{
						var containerStruct = containers[@ i];
						if (!is_undefined(containerStruct))
						{
							var container = {
								container_id: containerStruct[$ "container_id"] ?? undefined,
								inventory: undefined
							}
							var inventoryStruct = containerStruct[$ "inventory"] ?? undefined;
							if (!is_undefined(inventoryStruct))
							{
								container.inventory = ParseJSONStructToInventory(inventoryStruct);
							}
							array_push(room_data.containers, container);
						}
					}
				}
			}
			
			isSaveLoaded = true;
				
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		
		return isSaveLoaded;
	}
}