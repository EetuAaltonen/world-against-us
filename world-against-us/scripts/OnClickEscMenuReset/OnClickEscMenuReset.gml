function OnClickEscMenuReset()
{
	var gameSaveName = global.GameSaveHandlerRef.game_save_data.save_name;
	if (global.GameSaveHandlerRef.ResetGameSave(gameSaveName))
	{
		var notification = new Notification(
			sprFloppyDisk, "Game save reseted",
			string("Save: '{0}'", gameSaveName),
			NOTIFICATION_TYPE.Popup
		);
		global.NotificationHandlerRef.AddNotification(notification);
		// RETURN TO LOAD RESOURCES
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_LOAD_RESOURCES);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDiskBroken, "Error while reseting the game save",
				string("Create a new game save on the Main Menu!", gameSaveName),
				NOTIFICATION_TYPE.Popup
			)
		);
		// RETURN TO MAIN MENU
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
	}
}