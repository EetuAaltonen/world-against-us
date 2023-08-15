function GameSave(_save_name) constructor
{
	save_name = FormatSaveName(_save_name);
	save_file_name = ConcatSaveFileSuffix(save_name);
	player_data = undefined;
	room_data = undefined;
	
	ResetSaveData();
	isSaveLoadingFirstTime = true;
	
	static ToJSONStruct = function()
	{
		var formatRoomName = room_get_name(player_data.last_location.room_index);
		var formatPosition = player_data.last_location.position.ToJSONStruct();
		var formatBackpack = player_data.inventory.backpack.ToJSONStruct();
		
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
					ammo_pockets: undefined,
					medicine_pockets: undefined
				}
			} 
		}
	}
	
	static RoomToJSONStruct = function()
	{
		var formatRoomName = room_get_name(player_data.last_location.room_index);
		return {
			room_data: {
				name: formatRoomName
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
				
				// ROOM DATA
				if (!is_undefined(room_data))
				{
					room_data.index = room;
					
					isSaveDataFetched = true;	
				}
			}
		}
		
		return isSaveDataFetched;
	}
	
	static ResetSaveData = function()
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
				ammo_pockets: undefined,
				medicine_pockets: undefined
			}
		}
		
		room_data = {
			index: undefined
		}
	}
	
	static ParseGameSaveStruct = function(_gameSaveStruct)
	{
		var isSaveLoaded = false;
		try
		{
			var playerDataStruct = _gameSaveStruct[$ "player_data"];
			if (!is_undefined(playerDataStruct))
			{
				var lastLocationStruct = playerDataStruct[$ "last_location"];
				if (!is_undefined(lastLocationStruct))
				{
					var roomName = lastLocationStruct[$ "room_name"];
					if (!is_undefined(roomName))
					{
						var roomIndex = asset_get_index(roomName);
						player_data.last_location.room_index = (room_exists(roomIndex)) ? roomIndex : undefined;
						
						var positionStruct = lastLocationStruct[$ "position"];
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
				
				var inventoryStruct = playerDataStruct[$ "inventory"];
				if (!is_undefined(inventoryStruct))
				{
					var backpackStruct = inventoryStruct[$ "backpack"];
					if (!is_undefined(backpackStruct))
					{
						player_data.inventory.backpack = {
							inventory_id: "PlayerBackpack",
							items: []
						};
						
						var itemsArrayStruct = backpackStruct[$ "items"] ?? [];
						var itemCount = array_length(itemsArrayStruct);
						for (var i = 0; i < itemCount; i++)
						{
							var itemStruct = itemsArrayStruct[@ i];
							var item = ParseJSONStructToItem(itemStruct);
							array_push(player_data.inventory.backpack.items, item);
						}
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
}