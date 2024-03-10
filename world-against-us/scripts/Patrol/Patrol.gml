function Patrol(_patrolId, _regionId, _aiState, _travelTimer, _routeProgress, _targetNetworkId) constructor
{
	patrol_id = _patrolId;
	region_id = _regionId;
	ai_state = _aiState;
	travel_time = _travelTimer;
	
	// INSTANCE REF
	instance_ref = noone;
	position = new Vector2(0, 0);
	
	// PATROL ROUTE
	route = undefined;
	route_progress = _routeProgress;
	
	// TARGET
	target_network_id = _targetNetworkId;
	
	static ToJSONStruct = function()
	{
		return {
			patrol_id: patrol_id,
			region_id: region_id,
			ai_state: ai_state,
			travel_time: travel_time,
			route_progress: route_progress,
			target_network_id: target_network_id
		}
	}
	
	static InitRoute = function()
	{
		var isRouteInitialized = false;
		var pathLayerId = layer_get_id(LAYER_PATH_PATROL);
		if (layer_exists(pathLayerId))
		{
			// FETCH PATH INDEX BY ROOM
			var pathIndex = undefined;
			switch(room)
			{
				case roomTown: { pathIndex = pthPatrolTown; } break;
				case roomForest: { pathIndex = pthPatrolForest; } break;
			}
			
			if (!is_undefined(pathIndex))
			{
				// SET PATROL ROUTE
				route = new Path(pathIndex);
				isRouteInitialized = true;
			}
		}
		return isRouteInitialized;
	}
	
	static SyncState = function(_patrolState)
	{
		var isSynced = false;
		if (patrol_id == _patrolState.patrol_id)
		{
			if (instance_exists(instance_ref))
			{
				// SYNC AI STATE
				ai_state = _patrolState.ai_state;
				
				switch (_patrolState.ai_state)
				{
					case AI_STATE_BANDIT.PATROL:
					{
						route_progress = _patrolState.route_progress;
						
						// SYNC INSTANCE BEHAVIOR
						if (instance_exists(instance_ref))
						{
							isSynced = instance_ref.aiBandit.ResumePatrol();
						}
					} break;
					case AI_STATE_BANDIT.CHASE:
					{
						if (instance_exists(instance_ref))
						{
							var targetInstance = FindInstanceNetwork(_patrolState.target_network_id, objPlayer);
							if (instance_exists(targetInstance))
							{
								// SYNC INSTANCE BEHAVIOR
								with (instance_ref)
								{
									// END PATHING
									path_end();
								
									x = _patrolState.position.X;
									y = _patrolState.position.Y;
									
									// SET TARGET
									aiBandit.SetTargetInstance(targetInstance);
									
									// START CHASING TARGET
									isSynced = aiBandit.StartChasingTarget();
								}
							}
						}
					} break;
					case AI_STATE_BANDIT.PATROL_RETURN:
					{
						route_progress = _patrolState.route_progress;
						
						// SYNC INSTANCE BEHAVIOR
						if (instance_exists(instance_ref))
						{
							with (instance_ref)
							{
								// END PATHING
								path_end();
								
								x = _patrolState.position.X;
								y = _patrolState.position.Y;
									
								// START CHASING TARGET
								isSynced = aiBandit.ReturnToPatrol();
							}
						}
					} break;
					case AI_STATE_BANDIT.PATROL_END:
					{
						if (instance_exists(instance_ref))
						{
							instance_ref.aiBandit.EndPatrol();
							isSynced = true;
						}
					} break;
				}
			}
		}
		return isSynced;
	}
}