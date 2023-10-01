function OnClickMenuSaveSelectionDelete()
{
	var saveInput = parentElement.GetChildElementById("SaveInput");
	if (saveInput.input != saveInput.placeholder)
	{
		var saveName = FormatSaveName(saveInput.input);
		var saveFileName = ConcatSaveFileSuffix(saveName);
		
		CreateAndOpenWindowConfirm(
			GAME_WINDOW.Confirm,
			"Delete Save",
			string("Are you sure you want to delete '{0}'?", saveFileName),
			self, OnClickMenuSaveSelectionDeleteConfirmCallback
		);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDiskBroken,
				"No save file selected",
				undefined,
				NOTIFICATION_TYPE.Popup
			)
		);
	}
}