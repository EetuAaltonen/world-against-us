if (room != roomMainMenu)
{
	if (gameSaveHandler.LoadFromFile())
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDisk, "Save loaded", string("<-- {0}", gameSaveHandler.saveName))
		);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDiskBroken, "Error while loading the save", string("<-- {0}", gameSaveHandler.saveName))
		);
	}
}