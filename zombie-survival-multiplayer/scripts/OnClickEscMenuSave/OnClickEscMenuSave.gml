function OnClickEscMenuSave()
{
	if (global.GameSaveHandlerRef.SaveToFile())
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDisk, "Game saved", string("--> {0}", global.GameSaveHandlerRef.saveName))
		);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDiskBroken, "Error while saving the game", string("-->X {0}", global.GameSaveHandlerRef.saveName))
		);	
	}
}