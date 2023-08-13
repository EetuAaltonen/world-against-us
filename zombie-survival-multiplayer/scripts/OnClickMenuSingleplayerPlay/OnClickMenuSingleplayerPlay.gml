function OnClickMenuSingleplayerPlay()
{
	var saveInput = parentElement.GetChildElementById("SaveInput");
	if (saveInput.input != saveInput.placeholder)
	{
		if (string_length(saveInput.input) > 3)
		{
			global.GameSaveHandlerRef.SetSaveFileName(saveInput.input);
			room_goto(roomLoadResources);
		} else {
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"Save file name is too short (min 4)",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	} else {
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				undefined,
				"Save file name can't be empty",
				undefined,
				NOTIFICATION_TYPE.Log
			)
		);
	}
}