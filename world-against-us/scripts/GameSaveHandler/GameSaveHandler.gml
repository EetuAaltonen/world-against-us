function GameSaveHandler() constructor
{
	game_save_data = undefined;
	
	static InitGameSave = function(_saveName)
	{
		var isGameSaveInitialized = false;
		game_save_data = new GameSave(_saveName);
		
		if (!file_exists(game_save_data.save_file_name))
		{
			if (CreateEmptySaveFile(_saveName))
			{
				isGameSaveInitialized = true;
			}
		} else {
			isGameSaveInitialized = true;
		}
		
		return isGameSaveInitialized;
	}
	
	static ResetGameSave = function(_saveName)
	{
		var isGameSaveReseted = false;
		if (InitGameSave(_saveName))
		{
			// OVERWRITE EXISTING SAVE FILE
			if (CreateEmptySaveFile(_saveName))
			{
				if (DeleteRoomSaveFiles(_saveName))
				{
					isGameSaveReseted = true;
				}
			}
		}
		
		return isGameSaveReseted;
	}
	
	static CreateEmptySaveFile = function(_saveName)
	{
		var isEmptyFileCreated = false;
		try
		{
			var saveFileName = ConcatSaveFileSuffix(_saveName);
			var emptySaveString = EMPTY_SAVE_DATA;
			var buffer = buffer_create(
				string_byte_length(emptySaveString) + 1,
				buffer_fixed, 1
			);
			buffer_write(buffer, buffer_text, emptySaveString);
			buffer_save(buffer, saveFileName);
			buffer_delete(buffer);
			
			isEmptyFileCreated = true;
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isEmptyFileCreated;
	}
	
	static DeletePlayerSaveFile = function(_saveFileName)
	{
		var isSaveFileDeleted = false;
		try
		{
			if (file_exists(_saveFileName))
			{
				file_delete(_saveFileName);
				isSaveFileDeleted = true;
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isSaveFileDeleted;
	}
	
	static DeleteRoomSaveFiles = function(_saveName)
	{
		var isSaveFilesDeleted = false;
		try
		{
			var fileNamePrefix = string("{0}_save_room*", _saveName);
			var fileName = file_find_first(fileNamePrefix, fa_directory);
		
			while(fileName != EMPTY_STRING)
			{
				if (file_exists(fileName))
				{
					file_delete(fileName);
					fileName = file_find_next();
				} else {
					break;	
				}
			}
			file_find_close();
			isSaveFilesDeleted = true;
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isSaveFilesDeleted;
	}
	
	static FetchSaveFileNames = function(_saveFileNamesRef)
	{
		try
		{
			var fileName = file_find_first(string("*{0}", SAVE_FILE_SUFFIX_PLAYER_DATA), fa_directory);
		
			while(fileName != EMPTY_STRING)
			{
				ds_list_add(_saveFileNamesRef, fileName);
				fileName = file_find_next();
			}
			file_find_close();
			ds_list_sort(_saveFileNamesRef, true);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	
	static SaveGame = function()
	{
		var isGameSaved = false;
		if (game_save_data.FetchSaveData())
		{
			if (SaveToFile())
			{
				isGameSaved = true;
			}
		}
		return isGameSaved;
	}
	
	static SaveToFile = function()
	{
		var isSaveDataWritten = false;
		
		if (!is_undefined(game_save_data))
		{
			try
			{
				// PLAYER DATA
				var playerDataString = json_stringify(game_save_data.ToJSONStruct());
				var buffer = buffer_create(
					string_byte_length(playerDataString) + 1,
					buffer_fixed, 1
				);
				buffer_write(buffer, buffer_text, playerDataString);
				buffer_save(buffer, game_save_data.save_file_name);
				buffer_delete(buffer);
				
				// ROOM DATA
				var roomDataString = json_stringify(game_save_data.RoomToJSONStruct());
				var roomName = room_get_name(game_save_data.room_data.index);
				var roomDataFileName = ConcatRoomSaveFileSuffix(game_save_data.save_name, roomName);
				buffer = buffer_create(
					string_byte_length(roomDataString) + 1,
					buffer_fixed, 1
				);
				buffer_write(buffer, buffer_text, roomDataString);
				buffer_save(buffer, roomDataFileName);
				buffer_delete(buffer);

				isSaveDataWritten = true;
			} catch (error)
			{
				show_debug_message(error);
				show_message(error);
			}
		}
		
		return isSaveDataWritten;
	}
	
	static ClearSaveCache = function()
	{
		game_save_data.ResetSavePlayerData();
	}
	
	static ReadFromFile = function()
	{
		var isSaveDataReaded = false;
		if (!is_undefined(game_save_data))
		{
			if (!is_undefined(game_save_data.save_name))
			{
				try
				{
					if (file_exists(game_save_data.save_file_name))
					{
						var buffer = buffer_load(game_save_data.save_file_name);
						if (buffer_get_size(buffer) > 0)
						{
							var gameSaveString = buffer_read(buffer, buffer_text);
							buffer_delete(buffer);
							if (string_length(gameSaveString) > 0 && gameSaveString != EMPTY_SAVE_DATA)
							{
								var gameSaveStruct = json_parse(gameSaveString);
								if (game_save_data.ParseGameSaveStruct(gameSaveStruct))
								{
									isSaveDataReaded = true;
								}
							}
						}
					}
				} catch (error)
				{
					show_message(error);
					show_debug_message(error);
					
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							sprFloppyDisk, "Failed to load game save",
							string("Save: '{0}'", global.GameSaveHandlerRef.game_save_data.save_name),
							NOTIFICATION_TYPE.Popup
						)
					);
					global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
				}
			}
		}
		return isSaveDataReaded;
	}
	
	static ReadRoomDataFromFile = function()
	{
		var isRoomSaveReaded = false;
		if (!is_undefined(game_save_data))
		{
			if (!is_undefined(game_save_data.save_name))
			{
				try
				{
					var roomName = room_get_name(room);
					var roomDataFileName = ConcatRoomSaveFileSuffix(game_save_data.save_name, roomName);
					if (file_exists(roomDataFileName))
					{
						var buffer = buffer_load(roomDataFileName);
						if (buffer_get_size(buffer) > 0)
						{
							var gameRoomSaveString = buffer_read(buffer, buffer_text);
							buffer_delete(buffer);
							if (string_length(gameRoomSaveString) > 0 && gameRoomSaveString != EMPTY_SAVE_DATA)
							{
								var gameRoomSaveStruct = json_parse(gameRoomSaveString);
								if (game_save_data.ParseGameSaveRoomStruct(gameRoomSaveStruct))
								{
									isRoomSaveReaded = true;
								}
							}
						}
					}
				} catch (error)
				{
					show_message(error);
					show_debug_message(error);
					
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							sprFloppyDiskBroken, "Failed to load room data",
							string("Save: '{0}'", global.GameSaveHandlerRef.game_save_data.save_name),
							NOTIFICATION_TYPE.Popup
						)
					);
				}
			}
		}
		
		return isRoomSaveReaded;
	}
	
	static GetContainerContentById = function(_containerId)
	{
		var containerContent = undefined;
		
		if (!is_undefined(game_save_data))
		{
			if (!is_undefined(game_save_data.room_data))
			{
				var containers = game_save_data.room_data.containers;
				var containerCount = array_length(containers);
				for (var i = 0; i < containerCount; i++)
				{
					var container = containers[@ i];
					if (container.container_id == _containerId)
					{
						if (!is_undefined(container.inventory))
						{
							containerContent = container.inventory.items;
						}
					}
				}
			}
		}
		
		return containerContent;
	}
	
	static GetStructureInteractableContentById = function(_structureId)
	{
		var structureContent = undefined;
		
		if (!is_undefined(game_save_data))
		{
			if (!is_undefined(game_save_data.room_data))
			{
				var interactableStructures = game_save_data.room_data.structures_interactable;
				var structureCount = array_length(interactableStructures);
				for (var i = 0; i < structureCount; i++)
				{
					var structure = interactableStructures[@ i];
					if (structure.structure_id == _structureId)
					{
						structureContent = structure;
					}
				}
			}
		}
		
		return structureContent;
	}
}