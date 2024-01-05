function NetworkRegionObjectHandler() constructor
{
	active_inventory_stream = undefined;
	requested_container_access = undefined;
	// TODO: Move under the Region struct
	local_players = ds_list_create();
	local_patrols = ds_list_create();
	scouting_drone = undefined;
	
	patrol_update_timer = new Timer(TimerFromMilliseconds(300));
	patrol_update_timer.StartTimer();
	
	static OnDestroy = function()
	{
		active_inventory_stream = undefined;
		requested_container_access = undefined;
		
		DestroyDSListAndDeleteValues(local_players);
		local_players = undefined;
		
		DestroyDSListAndDeleteValues(local_patrols);
		local_patrols = undefined;
		
		scouting_drone = undefined;
	}
	
	static Update = function()
	{
		// SEND PATROL PROGRESS POSITION UPDATE
		var regionOwnerClient = global.NetworkRegionHandlerRef.owner_client;
		var clientId = global.NetworkHandlerRef.client_id;
		if (clientId != UNDEFINED_UUID)
		{
			if (clientId == regionOwnerClient)
			{
				var patrolCount = ds_list_size(local_patrols);
				if (patrolCount > 0)
				{
					// UPDATE PATROL LOCATION
					if (patrol_update_timer.IsTimerStopped())
					{
						var formatPatrols = [];
						for (var i = 0; i < patrolCount; i++)
						{
							var patrol = local_patrols[| i];
							patrol.Update();
							var formatPatrol = patrol.ToJSONStruct();
							var formatPosition = ScaleFloatValuesToIntVector2(patrol.local_position.X, patrol.local_position.Y);
							array_push(formatPatrols,
								{
									patrol_id: formatPatrol.patrol_id,
									route_progress: formatPatrol.route_progress,
									local_position: formatPosition
								}
							);
						}
						
						var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PATROLS_DATA_PROGRESS_POSITION);
						var networkPacket = new NetworkPacket(
							networkPacketHeader,
							{
								region_id: global.NetworkRegionHandlerRef.region_id,
								local_patrols: formatPatrols
							},
							PACKET_PRIORITY.DEFAULT,
							AckTimeoutFuncResend
						);
						if (global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
						{
							// SHOW SCOUT LIST LOADING ICON
							var scoutListWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenterScoutList);
							if (!is_undefined(scoutListWindow))
							{
								var scoutListLoadingElement = scoutListWindow.GetChildElementById("ScoutListLoading");
								if (!is_undefined(scoutListLoadingElement))
								{
									scoutListLoadingElement.isVisible = true;
								}
							}
						} else {
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Failed to queue patrol position update");
						}
						
						// RESET TIMER
						patrol_update_timer.StartTimer();
					} else {
						patrol_update_timer.Update();
					}
				}
			}
		}
		
		// INTERPOLATE SCOUTING DRONE MOVEMENT
		if (!is_undefined(scouting_drone))
		{
			if (instance_exists(scouting_drone.instance_ref))
			{
				scouting_drone.InterpolateMovement();
			}
		}
	}
	
	static ValidateRegionContainers = function()
	{
		var isContainersValid = true;
		var existContainerIds = [];
		var containerCount = instance_number(objContainerParent);
		for (var i = 0; i < containerCount; i++)
		{
			var containerInstance = instance_find(objContainerParent, i);
			if (!is_undefined(containerInstance))
			{
				// TODO: Check if container has 'containerId' and 'lootTableTag' properties
				if (!array_contains(existContainerIds, containerInstance.containerId))
				{
					array_push(existContainerIds, containerInstance.containerId);
				} else {
					isContainersValid = false;
					show_debug_message(string("Duplicate container ID {0} type of {1}", containerInstance.containerId, containerInstance.lootTableTag));
				}
			}
		}
		return isContainersValid;
	}
	
	static OnRoomEnd = function()
	{
		var patrolCount = ds_list_size(local_patrols);
		for (var i = 0; i < patrolCount; i++)
		{
			var banditInstance = local_patrols[| i];
			if (instance_exists(banditInstance))
			{
				switch (banditInstance.aiState)
				{
					case AI_STATE.CHASE:
					{
						// BROADCAST PATROL STATUS RESET IF TARGET IS LOCAL PLAYER
						if (banditInstance.targetInstance == global.InstancePlayer)
						{
							BroadcastPatrolState(banditInstance.patrolId, AI_STATE.PATROL);
						}
					} break;
					case AI_STATE.PATROL_RESUME:
					{
						// BROADCAST PATROL STATUS RESET IF PATROL IS RESUMING
						BroadcastPatrolState(banditInstance.patrolId, AI_STATE.PATROL);
					} break;
				}
			}
		}
		
		// CLEAR LOCAL PLAYERS
		ClearDSListAndDeleteValues(local_players);
		
		// CLEAR LOCAL PATROLS
		ClearDSListAndDeleteValues(local_patrols);
		
		// RESET PATROL UPDATE TIMER
		patrol_update_timer.StartTimer();
	}
	
	static SyncRegionPlayers = function(_players)
	{
		var isPlayersSync = true;
		// TODO: Check for existing players with same ID and sync their location
		var playerCount = array_length(_players);
		for (var i = 0; i < playerCount; i++)
		{
			var player = _players[@ i];
			if (!is_undefined(player))
			{
				var remotePlayerPosition = new Vector2(
					player.position.X,
					player.position.Y,
				);
				var remotePlayerInstanceObject = new InstanceObject(
					sprSoldierOriginaRemote, objPlayer,
					remotePlayerPosition
				);
				var spawnedPlayerInstance = global.SpawnHandlerRef.SpawnInstance(remotePlayerInstanceObject);
				if (spawnedPlayerInstance != noone)
				{
					// SET REMOTE PLAYER CHARACTER
					spawnedPlayerInstance.character = new CharacterHuman(
						player.name, CHARACTER_TYPE.Human,
						CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.REMOTE_PLAYER
					);
					// SET REMOTE PLAYER INSTANCE REF
					remotePlayerInstanceObject.instance_ref = spawnedPlayerInstance;
					// SET NETWORK ID
					remotePlayerInstanceObject.network_id = player.network_id;
					// SET DEVICE INPUT MOVEMENT
					spawnedPlayerInstance.movementInput = remotePlayerInstanceObject.device_input_movement;
					
					ds_list_add(local_players, remotePlayerInstanceObject);
				}
			}
		}
		return isPlayersSync;
	}
	
	static GetPlayerInstanceObjectById = function(_clientId)
	{
		var playerInstanceObject = undefined;
		var playerInstanceCount = ds_list_size(local_players);
		for (var i = 0; i < playerInstanceCount; i++)
		{
			var instanceObject = local_players[| i];
			if (!is_undefined(instanceObject))
			{
				if (instanceObject.network_id == _clientId)
				{
					if (instance_exists(instanceObject.instance_ref))
					{
						playerInstanceObject = instanceObject;
					} else {
						// DELETE EXPIRED PLAYER DATA
						DeleteDSListValueByIndex(local_players, i--);
						playerInstanceCount = ds_list_size(local_players);
					}
					break;
				}
			}
		}
		return playerInstanceObject;
	}
	
	static UpdateRegionRemotePosition = function(_remoteDataPositions)
	{
		var remoteCount = array_length(_remoteDataPositions);
		for (var i = 0; i < remoteCount; i++)
		{
			var remoteDataPosition = _remoteDataPositions[@ i];
			if (!is_undefined(remoteDataPosition))
			{
				var playerInstanceObject = GetPlayerInstanceObjectById(remoteDataPosition.network_id);
				if (!is_undefined(playerInstanceObject))
				{
					var scaledRemoteDataPosition = ScaleIntValuesToFloatVector2(
						remoteDataPosition.position.X,
						remoteDataPosition.position.Y
					);
					playerInstanceObject.position.X = scaledRemoteDataPosition.X;
					playerInstanceObject.position.Y = scaledRemoteDataPosition.Y;
					
					var playerInstanceRef = playerInstanceObject.instance_ref;
					if (instance_exists(playerInstanceRef))
					{
						playerInstanceRef.x = playerInstanceObject.position.X;
						playerInstanceRef.y = playerInstanceObject.position.Y;
					}
				}
			}
		}
	}
	
	static UpdateRegionRemoteInput = function(_remoteDataInput)
	{
		var deviceInputMovement = _remoteDataInput.device_input_movement;
		if (!is_undefined(deviceInputMovement))
		{
			var playerInstanceObject = GetPlayerInstanceObjectById(_remoteDataInput.network_id);
			if (!is_undefined(playerInstanceObject))
			{
				playerInstanceObject.device_input_movement.key_up = deviceInputMovement.key_up;
				playerInstanceObject.device_input_movement.key_down = deviceInputMovement.key_down;
				playerInstanceObject.device_input_movement.key_left = deviceInputMovement.key_left;
				playerInstanceObject.device_input_movement.key_right = deviceInputMovement.key_right;
			}
		}
	}
	
	static SpawnScoutingDrone = function(_instanceObject, _layerName)
	{
		var isDroneSpawned = true;
		if (is_undefined(scouting_drone))
		{
			scouting_drone = _instanceObject;
			var scoutingDroneInstance = global.SpawnHandlerRef.SpawnInstance(scouting_drone);
			scouting_drone.instance_ref = scoutingDroneInstance;
		} else {
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Trying to spawn a second scouting drone, max 1");	
		}
		return isDroneSpawned;
	}
	
	static UpdateScoutingDrone = function(_scoutingDroneData)
	{
		var isDroneSynced = false;
		if (!is_undefined(scouting_drone))
		{
			if (instance_exists(scouting_drone.instance_ref))
			{
				scouting_drone.StartInterpolateMovement(_scoutingDroneData.position, 300);
				isDroneSynced = true;
			}
		}
		return isDroneSynced;
	}
	
	static DestroyScoutingDrone = function(_scoutingDroneData)
	{
		var isDroneDestroyed = false;
		if (!is_undefined(scouting_drone))
		{
			if (instance_exists(scouting_drone.instance_ref))
			{
				instance_destroy(scouting_drone.instance_ref);
				scouting_drone = undefined;
			}
			isDroneDestroyed = true;
		}
		return isDroneDestroyed;
	}
	
	static SyncRegionPatrols = function (_patrols)
	{
		var isPatrolSync = true;
		// TODO: Check for existing patrols with same ID and sync their state / location
		var patrolCount = array_length(_patrols);
		for (var i = 0; i < patrolCount; i++)
		{
			var patrol = _patrols[@ i];
			if (!is_undefined(patrol))
			{
				// DON'T SPAWN PATROLS ON QUEUE
				if (patrol.ai_state != AI_STATE.QUEUE && patrol.travel_time <= 0)
				{
					var existingPatrol = GetPatrolById(patrol.patrol_id);
					if (!is_undefined(existingPatrol))
					{
						existingPatrol.Sync(patrol);
					} else {
						SpawnPatrol(patrol);
					}
				}
			}
		}
		return isPatrolSync;
	}
	
	static GetPatrolById = function(_patrolId)
	{
		var foundPatrol = undefined;
		var patrolCount = ds_list_size(local_patrols);
		for (var i = 0; i < patrolCount; i++)
		{
			var patrol = local_patrols[| i];
			if (!is_undefined(patrol))
			{
				if (patrol.patrol_id == _patrolId)
				{
					if (instance_exists(patrol.instance_ref))
					{
						foundPatrol = patrol;
					} else {
						// DELETE EXPIRED PATROL DATA
						DeleteDSListValueByIndex(local_patrols, i--);
						patrolCount = ds_list_size(local_patrols);
					}
					break;
				}
			}
		}
		return foundPatrol;
	}
	
	static SpawnPatrol = function(_patrol)
	{
		var isPatrolSpawned = false;
		var banditInstance = instance_create_layer(0, 0, LAYER_CHARACTERS, objBandit);
		banditInstance.patrolId = _patrol.patrol_id;
		banditInstance.patrolPathPercent = _patrol.route_progress;
		_patrol.instance_ref = banditInstance;
		ds_list_add(local_patrols, _patrol);
		return isPatrolSpawned;
	}
	
	static HandleRegionPatrolState = function(_patrolState)
	{
		var isPatrolStateHandled = false;
		if (_patrolState.region_id == global.NetworkRegionHandlerRef.region_id)
		{
			switch (_patrolState.ai_state)
			{
				case AI_STATE.PATROL:
				{
					var patrol = new Patrol(_patrolState.patrol_id, _patrolState.ai_state, 0, 0);
					isPatrolStateHandled = SyncRegionPatrols([patrol]);
				} break;
				case AI_STATE.PATROL_END:
				{
					var patrolCount = ds_list_size(local_patrols);
					for (var i = 0; i < patrolCount; i++)
					{
						var patrol = local_patrols[| i];
						var banditInstance = patrol.instance_ref;
						if (instance_exists(banditInstance))
						{
							if (banditInstance.patrolId == _patrolState.patrol_id)
							{
								instance_destroy(banditInstance);
								DeleteDSListValueByIndex(local_patrols, i--);
								patrolCount = ds_list_size(local_patrols);
								break;
							}
						}
					}
					isPatrolStateHandled = true;
				} break;
			}
		}
		return isPatrolStateHandled;
	}
	
	static ResetRegionObjectData = function()
	{
		active_inventory_stream = undefined;
		ClearDSListAndDeleteValues(local_patrols);
	}
}