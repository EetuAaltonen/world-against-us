var spawnPoint = new Vector2(x, y);

var roomIndex = room_get_name(room);
var cacheFastTravelInfo = global.FastTravelHandlerRef.GetCacheFastTravelInfo(roomIndex);
if (!is_undefined(cacheFastTravelInfo))
{
	var cacheLocalPosition = cacheFastTravelInfo.local_position;
	if (!is_undefined(cacheLocalPosition))
	{
		spawnPoint.X = cacheLocalPosition.X;
		spawnPoint.Y = cacheLocalPosition.Y;
	}
}

if (!global.MultiplayerMode)
{
	// SINGLEPLAYER
	var gameSaveData = global.GameSaveHandlerRef.game_save_data;
	if (!is_undefined(gameSaveData))
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
						spawnPoint.X = lastPosition.X;
						spawnPoint.Y = lastPosition.Y;
					}
				}
			}
		}
	}
}
instance_create_depth(spawnPoint.X, spawnPoint.Y, spawnPoint.Y, objPlayer);