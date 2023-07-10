function GameSaveHandler() constructor
{
	saveName = undefined;
	saveFileName = undefined;
	
	static SetSaveFileName = function(_saveName)
	{
		saveName = string_lettersdigits(string_replace_all(string_lower(_saveName), " ", "_"));
		saveFileName = string("{0}{1}", saveName, SAVE_FILE_SUFFIX);
		
		try
		{
			if (!file_exists(saveFileName))
			{
				var emptySaveString = EMPTY_SAVE_DATA;
				var buffer = buffer_create(
					string_byte_length(emptySaveString) + 1,
					buffer_fixed, 1
				);
				buffer_write(buffer, buffer_text, emptySaveString);
				buffer_save(buffer, saveFileName);
				buffer_delete(buffer);
			}
		} catch (error)
		{
			show_message(error);
		}
	}
	
	static FetchSaveFileNames = function()
	{
		var saveFileNames = ds_list_create();
		var fileName = file_find_first(string("*{0}", SAVE_FILE_SUFFIX), fa_directory);
		
		while(fileName != "")
		{
			ds_list_add(saveFileNames, fileName);
			fileName = file_find_next();
		}
		file_find_close();
		ds_list_sort(saveFileNames, true);
		return saveFileNames;
	}
	
	static SaveToFile = function()
	{
		var isFileSaved = false;
		var gameSave = new GameSave(saveName);
		gameSave.FetchSaveData();
		var gameSaveString = json_stringify(gameSave.ToJSONStruct());
		try
		{
			var buffer = buffer_create(
				string_byte_length(gameSaveString) + 1,
				buffer_fixed, 1
			);
			buffer_write(buffer, buffer_text, gameSaveString);
			buffer_save(buffer, saveFileName);
			buffer_delete(buffer);
			
			isFileSaved = true;
		} catch (error)
		{
			show_message(error);
		}
		return isFileSaved;
	}
	
	static ResetSaveFile = function()
	{
		var isFileReseted = false;
		try
		{
			var emptyString = "";
			var buffer = buffer_create(
				string_byte_length(emptyString) + 1,
				buffer_fixed, 1
			);
			buffer_write(buffer, buffer_text, emptyString);
			buffer_save(buffer, saveFileName);
			buffer_delete(buffer);
			
			isFileReseted = true;
		} catch (error)
		{
			show_message(error);
		}
		return isFileReseted;
	}
	
	static LoadPlayerDataFromFile = function()
	{
		var isPlayerDataLoaded = false;
		try
		{
			if (file_exists(saveFileName))
			{
				var buffer = buffer_load(saveFileName);
				if (buffer_get_size(buffer) > 0)
				{
					var gameSaveString = buffer_read(buffer, buffer_text);
					buffer_delete(buffer);
					if (string_length(gameSaveString) > 0 && gameSaveString != EMPTY_SAVE_DATA)
					{
						var gameSaveStruct = json_parse(gameSaveString);
						var gameSave = new GameSave(saveName);
						gameSave.ParseGameSavePlayerDataStruct(gameSaveStruct);
					}
				}
				isPlayerDataLoaded = true;
			}
		} catch (error)
		{
			show_message(error);
		}
		return isPlayerDataLoaded;
	}
	
	static LoadRoomDataFromFile = function()
	{
		var isRoomDataLoaded = false;
		try
		{
			if (file_exists(saveFileName))
			{
				var buffer = buffer_load(saveFileName);
				if (buffer_get_size(buffer) > 0)
				{
					var gameSaveString = buffer_read(buffer, buffer_text);
					buffer_delete(buffer);
					if (string_length(gameSaveString) > 0 && gameSaveString != EMPTY_SAVE_DATA)
					{
						var gameSaveStruct = json_parse(gameSaveString);
						var gameSave = new GameSave(saveName);
						gameSave.ParseGameSaveRoomDataStruct(gameSaveStruct);
					}
				}
				isRoomDataLoaded = true;
			}
		} catch (error)
		{
			show_message(error);
		}
		return isRoomDataLoaded;
	}
}