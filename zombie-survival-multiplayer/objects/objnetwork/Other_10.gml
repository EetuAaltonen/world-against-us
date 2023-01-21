/// @description Custom RoomStartEvent
// DISCONNECT FROM THE SERVERWHEN RETURNING TO MAINMENU
if (room == roomMainMenu)
{
	if (!is_undefined(client.clientId))
	{
		client.DisconnectFromHost();
		client.DeleteSocket();
	}
}