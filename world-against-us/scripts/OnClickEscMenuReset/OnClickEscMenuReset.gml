function OnClickEscMenuReset()
{
	var gameSaveName = global.GameSaveHandlerRef.game_save_data.save_name;
	if (global.GameSaveHandlerRef.ResetGameSave(gameSaveName))
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDisk, "Game save reseted",
				string("Save: '{0}'", gameSaveName),
				NOTIFICATION_TYPE.Popup
			)
		);
		room_goto(roomLoadResources);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDiskBroken, "Error while reseting the game save",
				string("Create a new game save on the Main Menu!", gameSaveName),
				NOTIFICATION_TYPE.Popup
			)
		);
		room_goto(roomMainMenu);
	}
}