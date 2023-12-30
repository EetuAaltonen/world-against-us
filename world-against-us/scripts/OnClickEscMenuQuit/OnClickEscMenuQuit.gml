function OnClickEscMenuQuit()
{
	if (global.MultiplayerMode)
	{
		global.NetworkHandlerRef.RequestDisconnectSocket();
	} else {
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
	}
}