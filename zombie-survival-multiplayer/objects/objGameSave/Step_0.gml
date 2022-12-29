// MANUAL SAVE
if (keyboard_check_released(vk_home))
{
	if (room != roomMainMenu)
	{
		if (gameSaveHandler.SaveToFile())
		{
			global.NotificationHandlerRef.AddNotification(
				new Notification(sprFloppyDisk, "Game saved", string("--> {0}", gameSaveHandler.saveName))
			);
		} else {
			global.NotificationHandlerRef.AddNotification(
				new Notification(sprFloppyDiskBroken, "Error while saving the game", string("-->X {0}", gameSaveHandler.saveName))
			);	
		}
	}
} else if (keyboard_check_released(vk_end))
{
	if (room != roomMainMenu)
	{
		if (gameSaveHandler.ResetSaveFile())
		{
			global.NotificationHandlerRef.AddNotification(
				new Notification(sprFloppyDiskBroken, "Save reseted", string("-->X {0}", gameSaveHandler.saveName))
			);
		}
	}
}