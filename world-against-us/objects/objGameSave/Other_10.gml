/// @description Custom RoomStartEvent
var gameSaveData = gameSaveHandler.game_save_data;
if (!is_undefined(gameSaveData))
{
	var roomIndex = gameSaveData.player_data.last_location.room_index;
	if (room == roomIndex)
	{
		// CHECK IF ROOM IS LOADING FIRST TIME FROM THE SAVE
		if (gameSaveData.isSaveLoadingFirstTime)
		{
			gameSaveHandler.ClearSaveCache();
			gameSaveData.isSaveLoadingFirstTime = false;
		}
	}
}