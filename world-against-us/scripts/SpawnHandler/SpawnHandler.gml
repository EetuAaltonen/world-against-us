function SpawnHandler() constructor
{
	spawn_point_object_index = objSpawnPoint;
	spawn_point = undefined;
	
	static OnDestroy = function()
	{
		// NO PROPERTIES TO DESTROY
	}
	
	static OnRoomStart = function()
	{
		// VALIDATE SPAWN POINT IN ROOM
		if (ValidateRoomSpawnPoint())
		{
			// SPAWN LOCAL PLAYER INSTANCE
			SpawnLocalPlayerInstance();
		} else {
			// TODO: Proper error handling
			global.ConsoleHandlerRef.AddConsoleLog(
				CONSOLE_LOG_TYPE.ERROR,
				"No single valid spawn point to spawn player instance"
			);
			if (global.MultiplayerMode)
			{
				global.NetworkHandlerRef.RequestDisconnectSocket(true);
			} else {
				global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);	
			}
		}
	}
	
	static OnRoomEnd = function()
	{
		// RESET SPAWN POINT
		spawn_point = undefined;
		// RESET GLOBAL VARIABLE
		global.InstancePlayer = noone;
	}
	
	static ValidateRoomSpawnPoint = function()
	{
		var isSpawnPointValid = false;
		var spawnPointInstance = noone;
		var spawnPointInstanceCount = instance_number(spawn_point_object_index);
		if (spawnPointInstanceCount == 1)
		{
			spawnPointInstance = instance_find(spawn_point_object_index, 0);
			if (instance_exists(spawnPointInstance))
			{
				spawn_point = new Vector2(spawnPointInstance.x, spawnPointInstance.y);
				isSpawnPointValid = true;
			}
		} else if (spawnPointInstanceCount > 1)
		{
			// TODO: Proper error handling
			global.ConsoleHandlerRef.AddConsoleLog(
				CONSOLE_LOG_TYPE.WARNING,
				"Room contains more spawn points than max count"
			);
		} else if (spawnPointInstanceCount <= 0)
		{
			// TODO: Proper error handling
			global.ConsoleHandlerRef.AddConsoleLog(
				CONSOLE_LOG_TYPE.WARNING,
				"Room contains not a single spawn point"
			);
		}
		return isSpawnPointValid;
	}
	
	static SpawnInstance = function(_instanceObject)
	{
		var spawnedInstance = noone;
		if (!is_undefined(_instanceObject))
		{
			var spawnedInstance = instance_create_depth(
				_instanceObject.position.X,
				_instanceObject.position.Y,
				_instanceObject.position.Y, 
				_instanceObject.obj_index
			);
			spawnedInstance.sprite_index = _instanceObject.spr_index;
		}
		return spawnedInstance;
	}
	
	static SpawnLocalPlayerInstance = function()
	{
		if (!is_undefined(spawn_point))
		{
			var playerInstanceObject = new InstanceObject(
				object_get_sprite(objPlayer),
				objPlayer, spawn_point
			);
			
			// LOAD SPAWN POINT FROM FAST TRAVEL INFO
			var roomIndex = room_get_name(room);
			var cacheFastTravelInfo = global.RoomChangeHandlerRef.GetCacheFastTravelInfo(roomIndex);
			if (!is_undefined(cacheFastTravelInfo))
			{
				var cacheLocalPosition = cacheFastTravelInfo.local_position;
				if (!is_undefined(cacheLocalPosition))
				{
					playerInstanceObject.position = new Vector2(cacheLocalPosition.X, cacheLocalPosition.Y);
				}
			}
			
			// OVERRIDE FAST TRAVEL INFO WITH GAME SAVE DATA
			if (!global.MultiplayerMode)
			{
				// SINGLEPLAYER
				// CHECK IF SAVE IS LOADING FIRST TIME
				if (global.GameSaveHandlerRef.is_save_loading_first_time)
				{
					var gameSaveData = global.GameSaveHandlerRef.game_save_data;
					if (!is_undefined(gameSaveData))
					{
						if (gameSaveData != EMPTY_SAVE_DATA)
						{
							if (!is_undefined(gameSaveData.player_data))
							{
								if (!is_undefined(gameSaveData.player_data.last_location))
								{
									var lastLocation = gameSaveData.player_data.last_location;
									if (!is_undefined(lastLocation))
									{
										if (!is_undefined(lastLocation.position))
										{
											if (lastLocation.position.X != 0 &&
												lastLocation.position.Y != 0)
											{
												playerInstanceObject.position = new Vector2(lastLocation.position.X, lastLocation.position.Y);
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			// SPAWN PLAYER INSTANCE WITH INSTANCE OBJECT DATA
			var playerInstance = SpawnInstance(playerInstanceObject);
			// FETCH CHARACTER FROM GLOBAL VARIABLE
			playerInstance.character = global.PlayerCharacter;
			// SET GLOBAL VARIABLE
			global.InstancePlayer = playerInstance;
		}
	}
	
	static SpawnRemotePlayerInstance = function(_remotePlayerInfo, _position)
	{
		var remotePlayerInstanceObject = new InstanceObject(
			sprSoldierOriginaRemote, objPlayer,
			_position
		);
		var spawnedPlayerInstance = global.SpawnHandlerRef.SpawnInstance(remotePlayerInstanceObject);
		if (spawnedPlayerInstance != noone)
		{
			// SET REMOTE PLAYER CHARACTER
			spawnedPlayerInstance.character = new CharacterHuman(
				_remotePlayerInfo.player_tag, CHARACTER_TYPE.Human,
				CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.REMOTE_PLAYER
			);
			// SET REMOTE PLAYER INSTANCE REF
			remotePlayerInstanceObject.instance_ref = spawnedPlayerInstance;
			// SET NETWORK ID
			remotePlayerInstanceObject.network_id = _remotePlayerInfo.client_id;
			// SET DEVICE INPUT MOVEMENT
			spawnedPlayerInstance.movementInput = remotePlayerInstanceObject.device_input_movement;
			
			// ADD INSTANCE OBJECT TO LOCAL PLAYER LIST
			ds_list_add(global.NetworkRegionObjectHandlerRef.local_players, remotePlayerInstanceObject);
		}
	}
}