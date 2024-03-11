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
		if (IS_ROOM_PATROL_ROUTED)
		{
			if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
			{
				// PATROL UPDATE
				patrol_update_timer.Update();
				if (patrol_update_timer.IsTimerStopped())
				{
					// FETCH PATROL SNAPSHOT DATA
					var patrolNetworkIDs = global.NPCPatrolHandlerRef.GetPatrolNetworkIDs();
					var patrolCount = array_length(patrolNetworkIDs);
					if (patrolCount > 0)
					{
						var formatPatrols = [];
						for (var i = 0; i < patrolCount; i++)
						{
							var patrol = global.NPCPatrolHandlerRef.GetPatrol(patrolNetworkIDs[@ i]);
							if (!is_undefined(patrol))
							{
								var patrolSnapshot = new PatrolSnapshot(
									patrol.patrol_id,
									patrol.route_progress,
									patrol.position
								);
								array_push(formatPatrols, patrolSnapshot.ToJSONStruct());
							}
						}
				
						// SEND PATROL SNAPSHOT NETWORK PACKET
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
						if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
						{
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Failed to queue patrol snapshot network packet");
						}
					}
				
					// RESTART PATROL UPDATE TIMER
					patrol_update_timer.StartTimer();
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
	
	static SyncRegionPatrolsSnapshot = function(_patrolsSnapshotData)
	{
		return global.NPCPatrolHandlerRef.SyncPatrolsSnapshot(_patrolsSnapshotData);
	}
	
	static ResetRegionObjectData = function()
	{
		active_inventory_stream = undefined;
	}
}