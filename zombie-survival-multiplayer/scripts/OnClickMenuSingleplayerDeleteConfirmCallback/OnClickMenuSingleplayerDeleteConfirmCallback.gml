function OnClickMenuSingleplayerDeleteConfirmCallback(callerWindowElement)
{
	if (!is_undefined(callerWindowElement))
	{
		var saveInput = callerWindowElement.parentElement.GetChildElementById("SaveInput");
		var saveName = FormatSaveName(saveInput.input);
		var saveFileName = ConcatSaveFileSuffix(saveName);
		
		try
		{
			if (file_exists(saveFileName))
			{
				file_delete(saveFileName);
				saveInput.input = saveInput.placeholder;
				
				// UPDATE SAVE FILE LIST
				var saveFiles = global.GameSaveHandlerRef.FetchSaveFileNames();
				var saveFileList = callerWindowElement.parentWindow.GetChildElementById("SaveFileList");
				if (!is_undefined(saveFileList))
				{
					saveFileList.UpdateDataCollection(saveFiles);
				}
			} else {
				ds_list_add(global.MessageLog, "Save file not found");
			}
		} catch (error)
		{
			show_message(error);
		}
	}
}