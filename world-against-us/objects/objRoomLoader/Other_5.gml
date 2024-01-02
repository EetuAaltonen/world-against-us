if (IS_ROOM_IN_GAME_WORLD)
{
	// RESET GAME SAVE ROOM DATA
	if (!is_undefined(global.GameSaveHandlerRef.game_save_room_data))
	{
		global.GameSaveHandlerRef.ResetGameSaveRoomData();
	}
}