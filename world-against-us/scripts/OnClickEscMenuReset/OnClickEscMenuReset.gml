function OnClickEscMenuReset()
{
	if (global.GameSaveHandlerRef.ResetSaveFile())
	{
		// RETURN TO LOAD RESOURCES
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_LOAD_RESOURCES);
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				sprFloppyDiskBroken, "Error while reseting the game save",
				"Create a new game save on the Main Menu!",
				NOTIFICATION_TYPE.Popup
			)
		);
		// RETURN TO MAIN MENU
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
	}
}