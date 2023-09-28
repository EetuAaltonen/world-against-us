var gameSaveData = global.GameSaveHandlerRef.game_save_data;
if (!is_undefined(gameSaveData))
{
	var spawnPoint = new Vector2(x, y);
	if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.OFFLINE)
	{
		// CHECK IF ROOM IS LOADING FIRST TIME FROM THE SAVE
		if (gameSaveData.isSaveLoadingFirstTime)
		{
			if (!is_undefined(gameSaveData.player_data))
			{
				if (!is_undefined(gameSaveData.player_data.last_location))
				{
					var lastPosition = gameSaveData.player_data.last_location.position;
					if (!is_undefined(lastPosition))
					{
						spawnPoint = new Vector2(lastPosition.X, lastPosition.Y);
					}
				}
			}
		}
	}		
	instance_create_depth(spawnPoint.X, spawnPoint.Y, spawnPoint.Y, objPlayer);
}