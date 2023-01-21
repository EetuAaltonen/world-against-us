/// @description Custom RoomStartEvent
if (room != roomLaunch && room != roomMainMenu)
{
	switch (room)
	{
		case roomLoadSave:
		{
			if (gameSaveHandler.LoadPlayerDataFromFile())
			{
				global.NotificationHandlerRef.AddNotification(
					new Notification(sprFloppyDisk, "Player data loaded", string("<-- {0}", gameSaveHandler.saveName))
				);
				// GOTO NEXT ROOM
				alarm[1] = roomTransitionTime;
			} else {
				global.NotificationHandlerRef.AddNotification(
					new Notification(sprFloppyDiskBroken, "Error while loading player data... returning to Main menu", string("<-- {0}", gameSaveHandler.saveName))
				);
				// GOTO TO MAIN MENU
				alarm[0] = roomTransitionTime;
			}
		} break;
		default:
		{
			if (gameSaveHandler.LoadRoomDataFromFile())
			{
				global.NotificationHandlerRef.AddNotification(
					new Notification(sprFloppyDisk, "Room data loaded", string("<-- {0}", gameSaveHandler.saveName))
				);
			} else {
				global.NotificationHandlerRef.AddNotification(
					new Notification(sprFloppyDiskBroken, "Error while loading room data... returning to Main menu", string("<-- {0}", gameSaveHandler.saveName))
				);
				// GOTO TO MAIN MENU
				alarm[0] = roomTransitionTime;
			}
		} break;
	}
}