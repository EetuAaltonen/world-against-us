// CLEAR ROOM SAVE DATA
if (room != roomLaunch && room != roomMainMenu && room != roomLoadResources)
{
	if (!is_undefined(global.GameSaveHandlerRef))
	{
		if (!is_undefined(global.GameSaveHandlerRef.game_save_data))
		{
			global.GameSaveHandlerRef.game_save_data.ResetSaveRoomData();
		}
	}
}