function OnClickEscMenuQuit()
{
	if (global.MultiplayerMode)
	{
		global.NetworkHandlerRef.RequestDisconnectSocket();
	} else {
		room_goto(roomMainMenu);
	}
}