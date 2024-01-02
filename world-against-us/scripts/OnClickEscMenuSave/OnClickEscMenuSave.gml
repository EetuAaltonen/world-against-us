function OnClickEscMenuSave()
{
	if (!global.GameSaveHandlerRef.SaveGame())
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDiskBroken, "Error while saving the game",
				string("Save: '{0}'", global.GameSaveHandlerRef.save_name),
				NOTIFICATION_TYPE.Popup
			)
		);
	}
}