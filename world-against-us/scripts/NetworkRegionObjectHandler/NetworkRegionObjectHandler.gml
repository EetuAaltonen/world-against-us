function NetworkRegionObjectHandler() constructor
{
	active_inventory_stream = undefined;
	// TODO: Move under the Region struct
	local_patrols = ds_list_create();
	scouting_drone = noone;
	
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
		
		// CLEAR LOCAL PATROLS
		ClearDSListAndDeleteValues(local_patrols);
	}
	
	static SpawnScoutingDrone = function(_instanceObject, _layerName)
	{
		var isDroneSpawned = true;
		if (scouting_drone != noone)
		{
			var existentDrone = instance_find(objDrone, 0);
			if (existentDrone != noone)
			{
				instance_destroy(existentDrone);
			}
		}
		
		var droneInstance = instance_create_layer(
			_instanceObject.position.X,
			_instanceObject.position.Y,
			LAYER_CHARACTERS,
			objDrone
		);
		scouting_drone = droneInstance;
		return isDroneSpawned;
	}
	
	static SyncScoutingDrone = function(_scoutingDroneData)
	{
		var isDroneSynced = false;
		if (scouting_drone != noone)
		{
			if (instance_exists(scouting_drone))
			{
				scouting_drone.x = _scoutingDroneData.position.X;
				scouting_drone.y = _scoutingDroneData.position.Y;
				isDroneSynced = true;
			}
		}
		return isDroneSynced
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
				// DON'T SPAWN PATROLS ON QUEUE
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