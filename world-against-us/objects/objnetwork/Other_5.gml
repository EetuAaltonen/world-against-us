if (global.MultiplayerMode)
{	
	if (room != roomMainMenu && room != roomLoadResources)
	{
		// TODO: Fix OnRoomEnd call to be included in future room change request logic
		// Any broadcast sent reach the server AFTER player gets fast-travelled
		// ON ALL IN-GAME ROOMS
		networkHandler.OnRoomEnd();
	}
}