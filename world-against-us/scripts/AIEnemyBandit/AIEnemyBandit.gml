function AIEnemyBandit(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) : AIEnemyHuman(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) constructor
{
	// PATROL
	patrol_route = undefined;
	patrol_route_progress = -1;
	patrol_route_last_position = undefined;
	
	OnCreate();
	
	static OnCreate = function()
	{
		// INITIALIZE PATROL ROUTE IN ROOM
		var pathLayerId = layer_get_id(LAYER_PATH_PATROL);
		if (layer_exists(pathLayerId))
		{
			var pathIndex = undefined;
			switch(room)
			{
				case roomTown: { pathIndex = pthPatrolTown; } break;
				case roomForest: { pathIndex = pthPatrolForest; } break;
			}
			
			if (!is_undefined(pathIndex))
			{
				// SET PATROL ROUTE
				patrol_route = new Path(pathIndex);
				
				// START PATROLLING
				ResumePatrol();
			}
		}
	}
	
	static OnDestroy = function(_struct = self)
	{
		// INHERIT PARENT METHOD
		static_get(static_get(AIEnemyBandit)).OnDestroy(_struct);
	}
	
	static Update = function()
	{
		return state_machine.Update(self);
	}
	
	static UpdatePatrolRouteProgress = function()
	{
		with (instance_ref)
		{
			other.patrol_route_progress	= path_position;
		}
	}
	
	static ResumePatrol = function()
	{
		var isPatrolResumed = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.PATROL))
		{
			// RESUME PATROL PATHING
			isPatrolResumed = ResumePatrolPathing();
			
			// START TARGET SEEK TIMER
			target_seek_timer.StartTimer();
		}
		return isPatrolResumed;
		
		// TODO: Fix networking
		/*// NETWORKING
		var patrolState = new PatrolState(
			global.NetworkRegionHandlerRef.region_id,
			patrolId, aiState,
			patrolRouteProgress,
			new Vector2(x, y),
			new Vector2(x, y)
		);
		BroadcastPatrolState(patrolState);*/
	}
	
	static ResumePatrolPathing = function()
	{
		var isPathingResumed = false;
		// START PATHING
		var pathingSpeed = !is_undefined(instance_ref.character) ? instance_ref.character.max_speed : 0;
		patrol_route_progress = max(0, patrol_route_progress);
		isPathingResumed = StartPathing(patrol_route.path, pathingSpeed, path_action_stop, true, patrol_route_progress);
		return isPathingResumed;
	}
	
	static SeekTargetInVision = function(_objectIndex)
	{
		var targetInstance = noone;
		if (instance_exists(instance_ref))
		{
			var visionRadius = (!is_undefined(character)) ? character.vision_radius : 0;
			targetInstance = GetNearestTargetInstanceInRadius(_objectIndex, visionRadius);
		}
		return targetInstance;
	}
	
	static StartChasingTarget = function(_targetInstance)
	{
		var isChaseStarted = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.CHASE))
		{
			// STOP TARGET SEEK TIMER
			target_seek_timer.StopTimer();
			
			// SET TARGET INSTANCE
			SetTargetInstance(_targetInstance);
			
			// START PATHING TO TARGET
			isChaseStarted = StartPathingToTarget();
		} else {
			// CONSOLE LOG
			var consoleLog = string("Failed to set AI state to {0} to Bandit with id {1}", AI_STATE_BANDIT.CHASE, _aiBase.instance_ref.id);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		}
		return isChaseStarted;
	}
	
	static ReturnToPatrol = function()
	{
		var isReturning = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.PATROL_RETURN))
		{
			// STOP PATH UPDATE TIMER
			path_update_timer.StopTimer();
			
			// STOP TARGET SEEK TIMER
			target_seek_timer.StopTimer();
			
			// RESET TARGET INSTANCE
			SetTargetInstance(undefined);
			
			// SET TARGET POSITION
			var yOffset = instance_ref.bbox_bottom - instance_ref.y;
			var lastRoutePoint = new Vector2(
				path_get_x(patrol_route.path, patrol_route_progress),
				path_get_y(patrol_route.path, patrol_route_progress) + yOffset
			);
			SetTargetPosition(lastRoutePoint);
			
			// START PATHING TO POINT
			isReturning = StartPathingToPoint();
		}
		return isReturning;
	}
	
	static EndPatrol = function()
	{
		var isPatrolEnded = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.PATROL_END))
		{
			// STOP TARGET SEEK TIMER
			target_seek_timer.StopTimer();
			
			// UPDATE INSTANCE BEHAVIOUR
			EndPathing();
			isPatrolEnded = true;
		}
		return isPatrolEnded;
	}
}