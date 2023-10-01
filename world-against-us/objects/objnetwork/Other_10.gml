/// @description Custom RoomStartEvent
// DISCONNECT FROM THE SERVER WHEN RETURNING TO MAINMENU
if (room == roomMainMenu)
{
	if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.TIMED_OUT)
	{
		global.NetworkHandlerRef.network_status = NETWORK_STATUS.OFFLINE;
		if (networkHandler.client_id != UNDEFINED_UUID)
		{
			networkHandler.DisconnectSocket();
		}
		show_message("Connection timed out :(");
	} else if (networkHandler.network_status != NETWORK_STATUS.OFFLINE)
	{
		if (networkHandler.client_id != UNDEFINED_UUID)
		{
			networkHandler.DisconnectSocket();
		}
	}
} else {
	if (room == roomLoadResources)
	{
		if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.CONNECTED_SAVE_SELECTED)
		{
			global.NetworkHandlerRef.RequestJoinGame();
		}
	}
}