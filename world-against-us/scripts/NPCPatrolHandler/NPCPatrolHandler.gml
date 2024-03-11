function NPCPatrolHandler() constructor
{
	local_patrols = ds_map_create();
	
	static OnDestroy = function(_struct = self)
	{
		DestroyDSMapAndDeleteValues(_struct.local_patrols);
		local_patrols = undefined;
	}
	
	static AddPatrol = function(_patrol)
	{
		var isPatrolAdded = false;
		if (!is_undefined(_patrol))
		{
			isPatrolAdded = ds_map_add(local_patrols, _patrol.patrol_id, _patrol);
		}
		return isPatrolAdded;
	}
	
	static SpawnPatrol = function(_patrol)
	{
		var isPatrolSpawned = false;
		if (!is_undefined(_patrol))
		{
			// INITIALIZE PATROL ROUTE
			_patrol.InitRoute();
			
			// SPAWN BANDIT INSTANCE
			var banditInstance = instance_create_layer(_patrol.position.X, _patrol.position.Y, LAYER_CHARACTERS, objBandit);
			
			// SET PATROL TO INSTANCE AI BASE
			banditInstance.aiBandit.patrol = _patrol;
			
			// SET INSTANCE REF TO PATROL
			_patrol.instance_ref = banditInstance;
			isPatrolSpawned = true;
		}
		return isPatrolSpawned;
	}
	
	static GetPatrol = function(_patrolId)
	{
		return local_patrols[? _patrolId] ?? undefined;
	}
	
	static GetPatrolNetworkIDs = function()
	{
		return ds_map_keys_to_array(local_patrols);
	}
	
	static SyncPatrols = function(_patrols)
	{
		var isPatrolsSynced = true;
		var patrolCount = array_length(_patrols);
		for (var i = 0; i < patrolCount; i++)
		{
			var patrol = _patrols[@ i];
			if (patrol.region_id == global.NetworkRegionHandlerRef.region_id)
			{
				var patrolState = new PatrolState(
					global.NetworkRegionHandlerRef.region_id,
					patrol.patrol_id, patrol.ai_state,
					patrol.route_progress, patrol.position,
					patrol.target_network_id
				);
				var existPatrol = GetPatrol(patrol.patrol_id);
				if (is_undefined(existPatrol))
				{
					var positionX = (!is_undefined(patrol.position)) ? patrol.position.X : 0;
					var positionY = (!is_undefined(patrol.position)) ? patrol.position.Y : 0;
					var newPatrol = new Patrol(patrol.patrol_id, patrol.region_id, AI_STATE_BANDIT.TRAVEL, positionX, positionY, UNDEFINED_UUID);
					if (AddPatrol(newPatrol))
					{
						if (SpawnPatrol(newPatrol))
						{
							isPatrolsSynced = newPatrol.SyncState(patrolState);
						}
					}
				} else {
					isPatrolsSynced = patrol.SyncState(patrolState);
				}
				
				if (!isPatrolsSynced)
				{
					var consoleLog = string("Failed to sync patrol with network ID {0}", patrol.patrol_id);
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
				}
			}
		}
		return isPatrolsSynced;
	}
	
	static SyncPatrolsSnapshot = function(_patrolsSnapshotData)
	{
		var isPatrolsSynced = false;
		if (_patrolsSnapshotData.region_id == global.NetworkRegionHandlerRef.region_id)
		{
			if (!global.NetworkRegionHandlerRef.IsClientRegionOwner())
			{
				if (is_array(_patrolsSnapshotData.local_patrols))
				{
					var patrolCount = array_length(_patrolsSnapshotData.local_patrols);
					for (var i = 0; i < patrolCount; i++)
					{
						var isExistPatrolSynced = false;
						var patrolSnapshot = _patrolsSnapshotData.local_patrols[i];
						if (!is_undefined(patrolSnapshot))
						{
							var existPatrol = GetPatrol(patrolSnapshot.patrol_id);
							if (!is_undefined(existPatrol))
							{
								var routeProgressDelta = abs(existPatrol.route_progress - patrolSnapshot.route_progress);
								var routeProgressThreshold = 0.02;
								var positionDelta = point_distance(
									existPatrol.position.X, existPatrol.position.Y,
									patrolSnapshot.position.X, patrolSnapshot.position.Y
								);
								var positionThreshold = MetersToPixels(2);
								if ((routeProgressDelta > routeProgressThreshold) || (positionDelta > positionThreshold))
								{
									var patrolState = new PatrolState(
										_patrolsSnapshotData.region_id, existPatrol.patrol_id,
										existPatrol.ai_state, patrolSnapshot.route_progress,
										patrolSnapshot.position, existPatrol.target_network_id
									);
									isExistPatrolSynced = existPatrol.SyncState(patrolState);
								} else {
									// PATROL IS ALREADY IN SYNC
									isExistPatrolSynced = true;
								}
							}
						}
					
						if (!isExistPatrolSynced)
						{
							var consoleLog = string("Failed to sync patrol from snapshot with patrol ID {0}", patrolSnapshot.patrol_id);
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
						}
					}
					isPatrolsSynced = true;
				}
			} else {
				// SET PATROLS SYNCED EVEN WHEN SKIPPED
				isPatrolsSynced = true;
			}
		}
		return isPatrolsSynced;
	}
	
	static SyncPatrolState = function(_patrolState)
	{
		var isStateSynced = false;
		if (!is_undefined(_patrolState))
		{
			if (_patrolState.region_id == global.NetworkRegionHandlerRef.region_id)
			{
				var patrol = GetPatrol(_patrolState.patrol_id);
				if (!is_undefined(patrol))
				{
					isStateSynced = patrol.SyncState(_patrolState);
				} else {
					var positionX = (!is_undefined(_patrolState.position)) ? _patrolState.position.X : 0;
					var positionY = (!is_undefined(_patrolState.position)) ? _patrolState.position.Y : 0;
					var newPatrol = new Patrol(_patrolState.patrol_id, _patrolState.region_id, AI_STATE_BANDIT.TRAVEL, positionX, positionY, UNDEFINED_UUID);
					if (AddPatrol(newPatrol))
					{
						if (SpawnPatrol(newPatrol))
						{
							isStateSynced = newPatrol.SyncState(_patrolState);
						}
					}
				}
			}
		}
		return isStateSynced;
	}
	
	static DeletePatrol = function(_patrolId)
	{
		DeleteDSMapValueByKey(local_patrols, _patrolId);
	}
	
	static ClearLocalPatrols = function()
	{
		ClearDSMapAndDeleteValues(local_patrols);
	}
	
	static OnRoomEnd = function()
	{
		ClearLocalPatrols();
	}
}