function OnClickEscMenuReset()
{
	if (global.GameSaveHandlerRef.ResetSaveFile())
	{
		global.NotificationHandlerRef.AddNotification(
			new Notification(sprFloppyDiskBroken, "Save reseted", string("-->X {0}", global.GameSaveHandlerRef.saveName))
		);
	}
}