// ROOM START AFTER
if (onRoomStartAfter)
{
	onRoomStartAfter = false;
	
	// DISCONNECT FROM THE SERVERWHEN RETURNING TO MAINMENU
	if (room == roomMainMenu)
	{
		if (!is_undefined(client.clientId))
		{
			client.DisconnectFromHost();
			client.DeleteSocket();
		}
	}
}