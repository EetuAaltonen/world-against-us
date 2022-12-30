function GameSaveHandler(_saveName) constructor
{
	saveName = _saveName;
	saveFileName = string("{0}.json", saveName);
	
	static SaveToFile = function()
	{
		var isFileSaved = false;
		var gameSave = new GameSave(saveName);
		gameSave.FetchSaveData();
		
		var gameSaveString = gameSave.ToJSONString();
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
		} catch (_error)
		{
			show_debug_message(_error);
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
		} catch (_error)
		{
			show_debug_message(_error);
		}
		return isFileReseted;
	}
	
	static LoadFromFile = function()
	{
		var isFileLoaded = false;
		try
		{
			if (file_exists(saveFileName))
			{
				var buffer = buffer_load(saveFileName);
				if (buffer_get_size(buffer) > 0)
				{
					var gameSaveString = buffer_read(buffer, buffer_text);
					buffer_delete(buffer);
					if (string_length(gameSaveString) > 0)
					{
						var gameSaveStruct = json_parse(gameSaveString);
						var gameSave = new GameSave(saveName);
						gameSave.ParseGameSaveStruct(gameSaveStruct);
				
						isFileLoaded = true;
					}
				}
			}
		} catch (_error)
		{
			show_debug_message(_error);
		}
		return isFileLoaded;
	}
}