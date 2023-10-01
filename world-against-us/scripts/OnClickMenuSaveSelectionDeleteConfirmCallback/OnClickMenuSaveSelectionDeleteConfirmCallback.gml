function OnClickMenuSaveSelectionDeleteConfirmCallback(callerWindowElement)
{
	if (!is_undefined(callerWindowElement))
	{
		var saveInput = callerWindowElement.parentElement.GetChildElementById("SaveInput");
		var saveName = FormatSaveName(saveInput.input);
		var saveFileName = ConcatSaveFileSuffix(saveName);
		
		if (global.GameSaveHandlerRef.DeletePlayerSaveFile(saveFileName))
		{
			if (global.GameSaveHandlerRef.DeleteRoomSaveFiles(saveName))
			{
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						sprFloppyDiskBroken,
						"Game save deleted",
						string("Save: '{0}'", saveName),
						NOTIFICATION_TYPE.Popup
					)
				);
			}
		}
		
		// UPDATE SAVE FILE LIST
		var saveFiles = global.GameSaveHandlerRef.FetchSaveFileNames();
		var saveFileList = callerWindowElement.parentWindow.GetChildElementById("SaveFileList");
		if (!is_undefined(saveFileList))
		{
			saveFileList.UpdateDataCollection(saveFiles);
		}
	}
}