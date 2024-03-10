if (global.MultiplayerMode)
{
	if (IS_ROOM_IN_GAME_WORLD)
	{
		// ON ALL IN-GAME ROOMS
		networkHandler.OnRoomEnd();
	}
}