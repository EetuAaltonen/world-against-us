if (global.GUIStateHandlerRef.IsGUIStateClosed())
{
	if (global.DEBUGMODE)
	{
		if (keyboard_check_released(ord("G")))
		{
			if (mapDataHandler.GenerateStaticMapData())
			{
				// NOTIFICATION LOG
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						undefined,
						string("Static map data generated: {0}", room_get_name(room)),
						undefined,
						NOTIFICATION_TYPE.Log
					)
				);
			} else {
				// NOTIFICATION LOG
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						undefined,
						string("Failed to generate static map data: {0}", room_get_name(room)),
						undefined,
						NOTIFICATION_TYPE.Log
					)
				);
			}
		}
	}
}

mapDataHandler.Update();