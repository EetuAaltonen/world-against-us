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
		
		var formatCharacter = player_data.character.ToJSONStruct();
		
		var formatMagazinePockets = player_data.inventory.magazine_pockets.ToJSONStruct();
		var formatMedicinePockets = player_data.inventory.medicine_pockets.ToJSONStruct();
		
		return {
			player_data: {
				last_location:
				{
					room_name: formatRoomName,
					position: formatPosition
				},
				character: formatCharacter,
				inventory:
				{
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
				containers: room_data.containers,
				structures_interactable: room_data.structures_interactable
			} 
		}
	}
	
	static FetchSaveData = function()
	{
		var isSaveDataFetched = false;
		
		if (!is_undefined(save_name))
		{
			// RESET GAME SAVE DATA CACHE
			ResetSavePlayerData();
			ResetSaveRoomData();
			
			// PLAYER DATA
			if (!is_undefined(player_data))
			{
				player_data.last_location.room_index = room;
				var scaledPosition = ScaleFloatValuesToIntVector2(
					global.InstancePlayer.x,
					global.InstancePlayer.y
				);
				player_data.last_location.position = scaledPosition;
				
				player_data.character = global.PlayerCharacter;
				
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
					
					// INTERACTABLE STRUCTURES
					var structureInstanceCount = instance_number(objStructureInteractableParent);
					for (var i = 0; i < structureInstanceCount; i++)
					{
						var structureInstance = instance_find(objStructureInteractableParent, i);
						if (instance_exists(structureInstance))
						{
							if (!is_undefined(structureInstance.structure))
							{
								var structureStruct = structureInstance.structure.ToJSONStruct();
								array_push(room_data.structures_interactable, structureStruct);
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
			character: undefined,
			inventory:
			{
				magazine_pockets: undefined,
				medicine_pockets: undefined
			}
		}
	}
	
	static ResetSaveRoomData = function()
	{
		room_data = {
			index: undefined,
			containers: [],
			structures_interactable: []
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
				
				var characterStruct = playerDataStruct[$ "character"] ?? undefined;
				if (!is_undefined(characterStruct))
				{
					player_data.character = ParseJSONStructToCharacter(characterStruct);
				}
				
				var inventoryStruct = playerDataStruct[$ "inventory"] ?? undefined;
				if (!is_undefined(inventoryStruct))
				{
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
				// CONTAINERS
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
				
				// STRUCTURES INTERACTABLE
				var structures = roomDataStruct[$ "structures_interactable"] ?? undefined;
				if (!is_undefined(structures))
				{
					var structureCount = array_length(structures);
					for (var i = 0; i < structureCount; i++)
					{
						var structureStruct = structures[@ i];
						if (!is_undefined(structureStruct))
						{
							var structureId = structureStruct[$ "structure_id"] ?? undefined
							if (!is_undefined(structureId))
							{
								var structureMetadataStruct = structureStruct[$ "metadata"] ?? undefined;
								if (!is_undefined(structureMetadataStruct))
								{
									var structureCategory = structureStruct[$ "category"] ?? undefined;
									if (!is_undefined(structureCategory))
									{
										var structure = undefined;
										
										switch (structureCategory)
										{
											case STRUCTURE_CATEGORY.Garden:
											{
												var structureMetadata = ParseJSONStructToMetadataStructureGarden(structureMetadataStruct);
												structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.Garden, structureMetadata);
											} break;
											
											case STRUCTURE_CATEGORY.ConstructionSite:
											{
												var structureMetadata = ParseJSONStructToMetadataStructureConstructionSite(structureMetadataStruct);
												structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.ConstructionSite, structureMetadata);
											} break;
										}
										
										if (!is_undefined(structure))
										{
											array_push(room_data.structures_interactable, structure);
										}
									}
								}
							}
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