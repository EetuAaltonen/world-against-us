function Patrol(_patrol_id, _ai_state, _travel_time, _route_progress) constructor
{
	patrol_id = _patrol_id;
	ai_state = _ai_state;
	travel_time = _travel_time;
	
	// INSTANCE REF
	instance_ref = noone;
	position = new Vector2(0, 0);
	
	// PATROL ROUTE
	route = undefined;
	route_progress = _route_progress;
	
	static ToJSONStruct = function()
	{
		return {
			patrol_id: patrol_id,
			ai_state: ai_state,
			travel_time: travel_time,
			route_progress: route_progress
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
	
	static Update = function()
	{
		if (instance_ref != noone)
		{
			ai_state = instance_ref.aiState;
			if (ai_state == AI_STATE_BANDIT.PATROL)
			{
				if (instance_ref.path_index != -1)
				{
					route_progress = instance_ref.path_position;
				} else {
					route_progress = 0;
				}
			}
			position.X = instance_ref.x;
			position.Y = instance_ref.y;
		}
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
	
	static Sync = function(_syncPatrol)
	{
		var isSynced = false;
		// TODO: Fix this logic
		/*var isSynced = false;
		if (patrol_id == _syncPatrol.patrol_id)
		{
			if (instance_exists(instance_ref))
			{
				ai_state = _syncPatrol.ai_state;
				instance_ref.aiState = ai_state;
				
				// TODO: SYNC PATROL STRUCT PROPERTIES
				
				// UPDATE INSTANCE BEHAVIOUR
				with (instance_ref)
				{
					aiState = _syncPatrol.ai_state;
					switch (aiState)
					{
						case AI_STATE_BANDIT.PATROL:
						{
							// STOP CURRENT PATHING
							path_end();
							
							// SYNC POSITION
							x = _syncPatrol.position.X;
							y = _syncPatrol.position.Y;
							
							// RESET PATHING
							patrolRouteProgress = _syncPatrol.route_progress;
							targetPosition = undefined;
							targetPath = undefined;
							initPath = true;
						} break;
						case AI_STATE_BANDIT.CHASE:
						{
							// STOP CURRENT PATHING
							path_end();
							
							// SYNC POSITION
							x = _syncPatrol.position.X;
							y = _syncPatrol.position.Y;
							
							// RESET PATHING
							targetPosition = _syncPatrol.target_position;
							targetPath = undefined;
							initPath = true;
						} break;
						case AI_STATE_BANDIT.PATROL_RETURN:
						{
							// STOP CURRENT PATHING
							path_end();
							
							// SYNC POSITION
							x = _syncPatrol.position.X;
							y = _syncPatrol.position.Y;
							
							// RESET PATHING
							patrolPathLastPosition = _syncPatrol.target_position;
							targetPosition = undefined;
							targetPath = undefined;
							initPath = true;
						} break;
						case AI_STATE_BANDIT.PATROL_END:
						{
							// TODO: SYNC PATROL END
						} break;
					}
				}
				isSynced = true;
			}
		}*/
		return isSynced;
	}
}