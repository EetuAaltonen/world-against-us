function AIEnemyBandit(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) : AIEnemyHuman(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) constructor
{
	// PATROL
	patrol = undefined;
	
	static OnDestroy = function(_struct = self)
	{
		// INHERIT PARENT METHOD
		static_get(static_get(AIEnemyBandit)).OnDestroy(_struct);
	}
	
	static Update = function()
	{
		return state_machine.Update(self);
	}
	
	static UpdatePatrolPosition = function()
	{
		with (instance_ref)
		{
			other.patrol.position.X = x;
			other.patrol.position.Y = y;
		}
	}
	
	static UpdatePatrolRouteProgress = function()
	{
		with (instance_ref)
		{
			other.patrol.route_progress = path_position;
		}
	}
	
	static ResumePatrol = function()
	{
		var isPatrolResumed = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.PATROL))
		{
			// RESUME PATROL PATHING
			if (ResumePatrolPathing())
			{
				// START TARGET SEEK TIMER
				target_seek_timer.StartTimer();
				isPatrolResumed = true;
			}
		}
		return isPatrolResumed;
	}
	
	static ResumePatrolPathing = function()
	{
		var isPathingResumed = false;
		// START PATHING
		var pathingSpeed = !is_undefined(instance_ref.character) ? instance_ref.character.max_speed : 0;
		patrol.route_progress = max(0, patrol.route_progress);
		isPathingResumed = StartPathing(patrol.route.path, pathingSpeed, path_action_stop, true, patrol.route_progress);
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
	
	static StartChasingTarget = function()
	{
		var isChaseStarted = false;
		// UPDATE AI STATE
		if (state_machine.SetState(AI_STATE_BANDIT.CHASE))
		{
			// START PATHING TO TARGET
			if (StartPathingToTarget())
			{
				// STOP TARGET SEEK TIMER
				target_seek_timer.StopTimer();
				
				// START PATH UPDATE TIMER
				path_update_timer.StartTimer();
				isChaseStarted = true;
			}
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
			var lastRoutePoint = patrol.route.GetPathPoint(patrol.route_progress);
			if (!is_undefined(lastRoutePoint))
			{
				lastRoutePoint.Y += yOffset;
				SetTargetPosition(lastRoutePoint);
			
				// START PATHING TO POINT
				isReturning = StartPathingToPoint();
			}
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
			
			// UPDATE INSTANCE BEHAVIOR
			EndPathing();
			
			// DELETE PATROL
			global.NPCPatrolHandlerRef.DeletePatrol(patrol.patrol_id);
		
			// NETWORKING
			if (global.MultiplayerMode)
			{
				if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
				{
					global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(self);
				}
			}
	
			// UPDATE INSTANCE BEHAVIOR
			if (instance_exists(instance_ref))
			{
				with (instance_ref)
				{
					// DESTROY INSTANCE
					instance_destroy();
				}
			}
			isPatrolEnded = true;
		}
		return isPatrolEnded;
	}
}