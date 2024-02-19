function GameSaveHandler() constructor
{
	save_name = EMPTY_STRING;
	save_file_name = EMPTY_STRING;
	game_save_data = undefined;
	game_save_room_data = undefined;
	is_save_loading_first_time = true;
	
	show_auto_save_icon = false;
	auto_save_icon_timer = new Timer(4000);
	
	static Update = function()
	{
		// AUTO SAVE ICON
		auto_save_icon_timer.Update();
		if (auto_save_icon_timer.IsTimerStopped())
		{
			auto_save_icon_timer.StopTimer();
			show_auto_save_icon = false;
		}
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
			ds_list_sort(_saveFileNamesRef, false);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
	}
	
	static InitGameSave = function(_saveName)
	{
		var isSaveInitialized = false;
		if (!is_undefined(_saveName))
		{
			if (_saveName != EMPTY_STRING)
			{
				save_name = FormatSaveName(_saveName);
				save_file_name = ConcatSaveFileSuffix(save_name);
				
				if (!file_exists(save_file_name))
				{
					if (CreateEmptySaveFile(save_file_name))
					{
						isSaveInitialized = true;
					}
				} else {
					isSaveInitialized = true;	
				}
			}
		}
		return isSaveInitialized;
	}
	
	static ResetGameSaveDataCache = function()
	{
		if (game_save_data != EMPTY_SAVE_DATA)
		{
			game_save_data.OnDestroy();
		}
		game_save_data = undefined;
	}
	
	static ResetGameSaveRoomData = function()
	{
		game_save_data.game_save_room_data.OnDestroy();
		game_save_data.game_save_room_data = undefined;
	}
	
	static CreateEmptySaveFile = function(_saveFileName)
	{
		var isEmptyFileCreated = false;
		try
		{
			var emptySaveString = EMPTY_SAVE_DATA;
			var buffer = buffer_create(
				string_byte_length(emptySaveString) + 1,
				buffer_fixed, 1
			);
			buffer_write(buffer, buffer_text, emptySaveString);
			buffer_save(buffer, _saveFileName);
			buffer_delete(buffer);
			
			isEmptyFileCreated = true;
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isEmptyFileCreated;
	}
	
	static ResetSaveFile = function()
	{
		var isGameSaveReseted = false;
		// DELETE SAVE FILE
		if (DeleteSaveFile(save_file_name))
		{
			// DELETE ROOM SAVE FILES
			if (DeleteRoomSaveFiles(save_name))
			{
				// CREATE EMPTY SAVE FILE
				if (CreateEmptySaveFile(save_file_name))
				{
					isGameSaveReseted = true;
				}
			}
		}
		return isGameSaveReseted;
	}
	
	static ReadSaveFromFile = function()
	{
		var isSaveDataReaded = false;
		try
		{
			if (save_file_name != EMPTY_STRING)
			{
				if (file_exists(save_file_name))
				{
					var saveFileBuffer = buffer_load(save_file_name);
					if (buffer_get_size(saveFileBuffer) > 0)
					{
						var gameSaveString = buffer_read(saveFileBuffer, buffer_text);
						if (string_length(gameSaveString) > 0)
						{
							if (gameSaveString != EMPTY_SAVE_DATA)
							{
								var gameSaveStruct = json_parse(gameSaveString);
								game_save_data = ParseJSONStructToGameSaveData(gameSaveStruct);
								if (!is_undefined(game_save_data))
								{
									// SET SAVE LOADIN FIRST TIME FLAG
									is_save_loading_first_time = true;
									isSaveDataReaded = true;
								}
							} else {
								game_save_data = EMPTY_SAVE_DATA;
								// SET SAVE LOADIN FIRST TIME FLAG
								is_save_loading_first_time = true;
								isSaveDataReaded = true;
							}
						}
					}
					buffer_delete(saveFileBuffer);
				}
			}
		} catch (error)
		{
			// TODO: Proper error handling
			show_message(error);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, string("Failed to load game save: '{0}'", save_name));
		}
		return isSaveDataReaded;
	}
	
	static SaveGame = function()
	{
		var isGameSaved = false;
		if (IS_ROOM_IN_GAME_WORLD)
		{
			if (game_save_data == EMPTY_SAVE_DATA)
			{
				// INIT NEW GAME SAVE DATA
				game_save_data = new GameSaveData(undefined);
				game_save_data.InitNewSave();
			}
			
			if (game_save_data.FetchSaveData())
			{
				if (WriteSaveToFile())
				{
					show_auto_save_icon = true;
					auto_save_icon_timer.StartTimer();
					isGameSaved = true;
				} else {
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Failed to write save data to file");
				}
			} else {
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Failed to fetch save data");
			}
		}
		return isGameSaved;
	}
	
	static WriteSaveToFile = function()
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
				buffer_save(buffer, save_file_name);
				buffer_delete(buffer);
				
				// ROOM DATA
				/*var roomDataString = json_stringify(game_save_data.RoomToJSONStruct());
				var roomName = room_get_name(game_save_data.room_data.index);
				var roomDataFileName = ConcatRoomSaveFileSuffix(game_save_data.save_name, roomName);
				buffer = buffer_create(
					string_byte_length(roomDataString) + 1,
					buffer_fixed, 1
				);
				buffer_write(buffer, buffer_text, roomDataString);
				buffer_save(buffer, roomDataFileName);
				buffer_delete(buffer);*/

				isSaveDataWritten = true;
			} catch (error)
			{
				show_debug_message(error);
				show_message(error);
			}
		}
		return isSaveDataWritten;
	}
	
	static DeleteSaveFile = function(_saveFileName)
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
	
	// TODO: Fix these functions and related logic
	/*
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
	}*/
}