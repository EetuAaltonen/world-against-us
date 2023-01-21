function OnClickEscMenuReset()
{
	if (global.GameSaveHandlerRef.ResetSaveFile())
	{
		// TODO: Reseting save doesn't clear inventory items etc.
		// Make sure to perform full clean up
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDiskBroken, "Save reseted", string("-->X {0}", global.GameSaveHandlerRef.saveName))
		);
		room_goto(roomLoadSave);
	}
}