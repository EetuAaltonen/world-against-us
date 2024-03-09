function NetworkRegionRemotePlayerHandler() constructor
{
	remote_players = ds_map_create();
	
	static OnDestroy = function(_struct = self)
	{
		DestroyDSMapAndDeleteValues(_struct.remote_players);
		remote_players = undefined;
	}
	
	static Update = function()
	{
		// INTERPOLATE REMOTE PLAYER MOVEMENT
		var networkIDs = ds_map_keys_to_array(remote_players);
		var networkIDCount = array_length(networkIDs);
		for (var i = 0; i < networkIDCount; i++)
		{
			var playerInstanceObject = GetRemotePlayer(networkIDs[@ i]);
			if (!is_undefined(playerInstanceObject))
			{
				playerInstanceObject.InterpolateMovement();
			}
		}
	}
	
	static AddRemotePlayer = function(_playerInstanceObject)
	{
		var isPlayerAdded = false;
		if (!is_undefined(_playerInstanceObject))
		{
			isPlayerAdded = ds_map_add(remote_players, _playerInstanceObject.network_id, _playerInstanceObject);
		}
		return isPlayerAdded;
	}
	
	static GetRemotePlayer = function(_networkId)
	{
		return remote_players[? _networkId] ?? undefined;
	}
	
	static SyncRegionRemotePlayers = function(_players)
	{
		var isPlayersSynced = true;
		var playerCount = array_length(_players);
		for (var i = 0; i < playerCount; i++)
		{
			isPlayersSynced = false;
			var playerData = _players[@ i];
			if (!is_undefined(playerData))
			{
				// DON'T SYNC LOCAL PLAYER
				if (playerData.network_id != global.NetworkHandlerRef.client_id)
				{
					var existPlayer = GetRemotePlayer(playerData.network_id);
					if (is_undefined(existPlayer))
					{
						var remoteInstanceObject = new InstanceObject(
							object_get_sprite(objPlayer), objPlayer,
							playerData.position, playerData.network_id
						);
						if (AddRemotePlayer(remoteInstanceObject))
						{
							var remotePlayerInfo = new RemotePlayerInfo(
								playerData.network_id,
								playerData.name
							);
							
							// SPAWN REMOTE PLAYER
							global.SpawnHandlerRef.SpawnRemotePlayerInstance(remoteInstanceObject, remotePlayerInfo);
							isPlayersSynced = true;
						}
					} else {
						// REMOTE PLAYER ALREADY SYNCRONIZED
						isPlayersSynced = true;
					}
				} else {
					// SET SYNCED EVEN WHEN SKIPPED
					isPlayersSynced = true;
				}
			}
			
			if (!isPlayersSynced)
			{
				var consoleLog = string("Failed to sync remote player with network ID {0}", playerData.network_id);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
			}
		}
		return isPlayersSynced;
	}
	
	static SyncRegionRemotePlayerEnter = function(_remotePlayerInfo)
	{
		var isSynced = false;
		if (!is_undefined(_remotePlayerInfo))
		{
			// TODO: Check if initial position is possible set before REMOTE_ENTERED_THE_INSTANCE message
			var remotePlayerData = new PlayerData(_remotePlayerInfo.client_id, _remotePlayerInfo.player_tag, new Vector2(0, 0));
			isSynced = SyncRegionRemotePlayers([remotePlayerData]);
		}
		return isSynced;
	}
	
	static UpdateRegionRemotePosition = function(_remoteInstanceObject)
	{
		if (!is_undefined(_remoteInstanceObject))
		{
			var playerInstanceObject = GetRemotePlayer(_remoteInstanceObject.network_id);
			if (!is_undefined(playerInstanceObject))
			{
				var positionThreshold = 50;
				var distance = point_distance(
					_remoteInstanceObject.position.X,
					_remoteInstanceObject.position.Y,
					playerInstanceObject.position.X,
					playerInstanceObject.position.Y
				);
				if (distance > positionThreshold)
				{
					var playerInstanceRef = playerInstanceObject.instance_ref;
					if (instance_exists(playerInstanceRef))
					{
						playerInstanceObject.position.X = playerInstanceRef.x;
						playerInstanceObject.position.Y = playerInstanceRef.y;
						playerInstanceObject.start_position = playerInstanceObject.position;
						playerInstanceObject.StartInterpolateMovement(_remoteInstanceObject.position, 50);
					}
				}
			}
		}
	}
	
	static UpdateRegionRemoteInput = function(_remoteDataInput)
	{
		if (!is_undefined(_remoteDataInput))
		{
			var deviceInputMovement = _remoteDataInput.device_input_movement;
			if (!is_undefined(deviceInputMovement))
			{
				var playerInstanceObject = GetRemotePlayer(_remoteDataInput.network_id);
				if (!is_undefined(playerInstanceObject))
				{
					playerInstanceObject.device_input_movement.key_up = deviceInputMovement.key_up;
					playerInstanceObject.device_input_movement.key_down = deviceInputMovement.key_down;
					playerInstanceObject.device_input_movement.key_left = deviceInputMovement.key_left;
					playerInstanceObject.device_input_movement.key_right = deviceInputMovement.key_right;
				}
			}
		}
	}
	
	static SyncRegionRemotePlayerLeave = function(_remotePlayerInfo)
	{
		var isRemotePlayerSynced = false;
		var instanceObject = GetRemotePlayer(_remotePlayerInfo.client_id);
		if (!is_undefined(instanceObject))
		{
			// DESTROY INSTANCE
			if (instance_exists(instanceObject.instance_ref))
			{
				with (instanceObject.instance_ref)
				{
					instance_destroy();
				}
			}
			
			// REMOVE REMOTE PLAYER INSTANCE OBJECT
			DeleteRemotePlayer(_remotePlayerInfo.client_id);
			isRemotePlayerSynced = true;
		} else {
			// NO RECORDS ABOUT LEAVING PLAYER
			isRemotePlayerSynced = true;
		}
		
		if (!isRemotePlayerSynced)
		{
			var consoleLog = string("Unable to destroy unknown remote player instance object with network ID '{0}'", _remotePlayerInfo.client_id);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);	
		}
		return isRemotePlayerSynced;
	}
	
	static SyncRegionRemotePlayerReturnCamp = function(_remotePlayerInfo)
	{
		var isRemotePlayerSynced = true;
		// CHECK IF REMOTE PLAYER EXISTS IN CURRENT REGION
		var instanceObject = GetRemotePlayer(_remotePlayerInfo.client_id);
		if (!is_undefined(instanceObject))
		{
			isRemotePlayerSynced = SyncRegionRemotePlayerLeave(_remotePlayerInfo);
		}
		return isRemotePlayerSynced;
	}
	
	static SyncRegionRemotePlayerDisconnect = function(_remotePlayerInfo)
	{
		var isRemotePlayerSynced = true;
		// CHECK IF REMOTE PLAYER EXISTS IN CURRENT REGION
		var instanceObject = GetRemotePlayer(_remotePlayerInfo.client_id);
		if (!is_undefined(instanceObject))
		{
			isRemotePlayerSynced = SyncRegionRemotePlayerLeave(_remotePlayerInfo);
		}
		return isRemotePlayerSynced;
	}
	
	static DeleteRemotePlayer = function(_networkId)
	{
		DeleteDSMapValueByKey(remote_players, _networkId);
	}
	
	static ClearRemotePlayers = function()
	{
		ClearDSMapAndDeleteValues(remote_players);
	}
	
	static OnRoomEnd = function()
	{
		ClearRemotePlayers();
	}
	
	static Draw = function()
	{
		if (global.DEBUGMODE)
		{
			// REMOTE PLAYER POSITION ON SERVER
			var networkIDs = ds_map_keys_to_array(remote_players);
			var networkIDCount = array_length(networkIDs);
			if (networkIDCount > 0)
			{
				for (var i = 0; i < networkIDCount; i++)
				{
					var playerInstanceObject = GetRemotePlayer(networkIDs[@ i]);
					if (!is_undefined(playerInstanceObject))
					{
						if (!is_undefined(playerInstanceObject.target_position))
						{
							draw_circle_color(
								playerInstanceObject.target_position.X,
								playerInstanceObject.target_position.Y,
								4, c_red, c_red, false
							);
						}
					}
				}
			}
		}
	}
}