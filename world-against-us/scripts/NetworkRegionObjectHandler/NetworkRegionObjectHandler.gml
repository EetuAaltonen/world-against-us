function NetworkRegionObjectHandler() constructor
{
	active_inventory_stream = undefined;
	requested_container_access = undefined;
	
	scouting_drone = undefined;
	
	patrol_update_timer = new Timer(500);
	patrol_update_timer.StartTimer();
	
	static OnDestroy = function()
	{
		active_inventory_stream = undefined;
		requested_container_access = undefined;
		
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
				// TODO: Fix patrol logic
				/*var patrolCount = ds_list_size(local_patrols);
				if (patrolCount > 0)
				{
					
					// UPDATE PATROL LOCATION
					patrol_update_timer.Update();
					if (patrol_update_timer.IsTimerStopped())
					{
						var formatPatrols = [];
						for (var i = 0; i < patrolCount; i++)
						{
							var patrol = local_patrols[| i];
							patrol.Update();
							
							var formatPatrol = patrol.ToJSONStruct();
							var formatPosition = new Vector2(0, 0);
							// UPDATE LOCATION ONLY OUTSIDE THE ROUTE
							if (patrol.ai_state != AI_STATE_BANDIT.PATROL)
							{
								formatPosition = ScaleFloatValuesToIntVector2(patrol.position.X, patrol.position.Y);
							}
							array_push(formatPatrols,
								{
									patrol_id: formatPatrol.patrol_id,
									route_progress: formatPatrol.route_progress,
									position: formatPosition
								}
							);
						}
						
						var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA);
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
					}
				}*/
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
					var consoleLog = string("Duplicate container object type of {0} with container ID {0} and loot table tag {1}", object_get_name(containerInstance.object_index), containerInstance.containerId, containerInstance.lootTableTag);
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
				}
			}
		}
		return isContainersValid;
	}
	
	static OnRoomEnd = function()
	{
		// RESET SCOTING DRONE
		scouting_drone = undefined;
		
		// RESET PATROL UPDATE TIMER
		patrol_update_timer.StartTimer();
	}
	
	static UpdateRegionFromSnapshot = function(_regionSnapshot)
	{
		// UPDATE LOCAL PLAYERS
		/*var playerCount = _regionSnapshot.local_player_count;
		for (var i = 0; i < playerCount; i++)
		{
			var playerData = _regionSnapshot.local_players[@ i];
			if (!is_undefined(playerData))
			{
				// DON'T UPDATE LOCAL PLAYER
				if (playerData.network_id != global.NetworkHandlerRef.client_id)
				{
					var playerInstanceObject = GetPlayerInstanceObjectById(playerData.network_id);
					if (!is_undefined(playerInstanceObject))
					{
						var distance = point_distance(
							playerData.position.X,
							playerData.position.Y,
							playerInstanceObject.position.X,
							playerInstanceObject.position.Y
						);
						if (distance > 30)
						{
							playerInstanceObject.position.X = playerData.position.X;
							playerInstanceObject.position.Y = playerData.position.Y;
							
							var playerInstanceRef = playerInstanceObject.instance_ref;
							if (instance_exists(playerInstanceRef))
							{
								playerInstanceRef.x = playerInstanceObject.position.X;
								playerInstanceRef.y = playerInstanceObject.position.Y;
							}
						}
					} else {
						var consoleLog = string("Unable to update position for unknown remote player instance object with network ID '{0}'", playerData.network_id);
						global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);	
					}
				}
			}
		}*/
		
		// UPDATE LOCAL PATROLS
		// CHECK IF CLIENT HAS AUTHORITY ON THE REGION
		/*if (global.NetworkRegionHandlerRef.owner_client != global.NetworkHandlerRef.client_id)
		{
			// TODO: Fix random patrol teleporting on chase start
			var patrolCount = _regionSnapshot.local_patrol_count;
			for (var i = 0; i < patrolCount; i++)
			{
				var patrolData = _regionSnapshot.local_patrols[@ i];
				if (!is_undefined(patrolData))
				{
					var patrol = GetPatrolById(patrolData.patrol_id);
					if (!is_undefined(patrol))
					{
						if (instance_exists(patrol.instance_ref))
						{
							switch (patrol.ai_state)
							{
								case AI_STATE_BANDIT.PATROL:
								{
									if (patrol.instance_ref.path_index != -1)
									{
										show_debug_message(string("patrol.instance_ref.path_position - patrolData.route_progress) == {0}", (patrol.instance_ref.path_position - patrolData.route_progress) * 1000 ));
										if (patrol.instance_ref.path_position < patrolData.route_progress)
										{
											patrol.instance_ref.path_position = patrolData.route_progress;
										}
									}
								} break;
								default:
								{
									patrol.instance_ref.x = patrolData.position.X;
									patrol.instance_ref.y = patrolData.position.Y;
								}
							}
						}
					}
				}
			}
		}*/
	}
	
	static SpawnScoutingDrone = function(_instanceObject)
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
	
	static BroadcastPatrolState = function(_aiBase)
	{
		var isStateBroadcasted = false;
		if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
		{
			var instanceOriginPosition = GetInstanceOriginPosition(_aiBase.instance_ref);
			if (!is_undefined(instanceOriginPosition))
			{
				var targetInstanceNetworkId = (instance_exists(_aiBase.target_instance)) ? (_aiBase.target_instance.networkId ?? UNDEFINED_UUID) : UNDEFINED_UUID;
				var patrolState = new PatrolState(
					global.NetworkRegionHandlerRef.region_id,
					_aiBase.patrol.patrol_id,
					_aiBase.GetStateIndex(),
					_aiBase.patrol.route_progress,
					instanceOriginPosition,
					targetInstanceNetworkId
				);
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_PATROL_STATE);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					patrolState.ToJSONStruct(),
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					isStateBroadcasted = true;
				} else {
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Failed to queue sync patrol state on broadcast");
				}
			}
		}
		return isStateBroadcasted;
	}
	
	static SyncRegionPatrols = function(_patrols)
	{
		return global.NPCPatrolHandlerRef.SyncPatrols(_patrols);
	}
	
	static SyncRegionPatrolState = function(_patrolState)
	{
		return global.NPCPatrolHandlerRef.SyncPatrolState(_patrolState);
	}
	
	static ResetRegionObjectData = function()
	{
		active_inventory_stream = undefined;
	}
}