// INHERIT THE PARENT EVENT
event_inherited();

var checkChaseCondition = function()
{
	var nearestTargetInstance = instance_nearest(x, y, objPlayer);
	if (instance_exists(nearestTargetInstance))
	{
		var targetPos = new Vector2(
			(nearestTargetInstance.bbox_left + ((nearestTargetInstance.bbox_right - nearestTargetInstance.bbox_left) * 0.5)),
			max(nearestTargetInstance.y, nearestTargetInstance.bbox_bottom)
		);
		var distanceToTarget = point_distance(x, y, targetPos.X, targetPos.Y);
		if (distanceToTarget <= visionRadius)
		{
			if (!is_undefined(nearestTargetInstance.character))
			{
				if (!nearestTargetInstance.character.IsInvulnerableState())
				{
					aiState = AI_STATE.CHASE;
					
					// NETWORKING
					BroadcastPatrolState(patrolId, aiState);
					
					// CACHE CURRENT PATROL STEP
					if (targetPath == patrolPath)
					{
						patrolPathPercent = path_position;
						patrolPathLastPosition = new Vector2(
							path_get_x(path_index, patrolPathPercent),
							path_get_y(path_index, patrolPathPercent)
						);
					}
					path_end();
					// SET NEW TARGET
					targetInstance = nearestTargetInstance;
					// START CHASE PATH UPDATE TIMER
					chasePathUpdateTimer.StartTimer();
				}
			}
		}
	}
}

var resumePatrolling = function()
{
	path_end();
	aiState = AI_STATE.PATROL_RESUME;
	targetInstance = noone;
	targetPath = undefined;
	
	// NETWORKING
	BroadcastPatrolState(patrolId, aiState);
	
	// CLEAR CHASE PATH POINTS
	path_clear_points(pathToTarget);
	
	// STOP CHASE PATH UPDATE TIMER
	chasePathUpdateTimer.StopTimer();
}

var continuePatrolling = function()
{
	// CONTINUE PATROLLING
	aiState = AI_STATE.PATROL;
	targetPath = patrolPath;
	path_start(targetPath, maxSpeed, path_action_stop, true);
	path_position = max(0, patrolPathPercent);
	
	// NETWORKING
	BroadcastPatrolState(patrolId, aiState);

	// CLEAR PATROL CACHE
	patrolPathPercent = -1;
	patrolPathLastPosition = undefined;
}

// AI BEHAVIOUR
switch (aiState)
{
	case AI_STATE.PATROL:
	{
		if (!is_undefined(targetPath))
		{
			if (path_position == 1) {
				path_end();
				aiState = AI_STATE.PATROL_END;
			} else {
				checkChaseCondition();
			}
		} else {
			path_end();
			aiState = AI_STATE.TRAVEL;
		}
	} break;
	case AI_STATE.CHASE:
	{
		if (!instance_exists(targetInstance))
		{
			resumePatrolling();
		} else {
			if (!targetInstance.character.IsInvulnerableState())
			{
				var targetPos = new Vector2(
					(targetInstance.bbox_left + ((targetInstance.bbox_right - targetInstance.bbox_left) * 0.5)),
					targetInstance.bbox_bottom
				);
				var distanceToTarget = point_distance(x, y, targetPos.X, targetPos.Y);
				if (distanceToTarget <= (pathBlockingRadius * 4))
				{
					global.PlayerDataHandlerRef.OnRobbed();
					resumePatrolling();
				} else {
					chasePathUpdateTimer.Update();
					if (chasePathUpdateTimer.IsTimerStopped())
					{
						if (distanceToTarget > visionRadius)
						{
							resumePatrolling();
						} else {
							// CALCULATE NEW PATH TO TARGET
							path_clear_points(pathToTarget);
							if (mp_grid_path(global.ObjGridPath.roomGrid, pathToTarget, x, y, targetPos.X, targetPos.Y, true))
							{
								targetPath = pathToTarget;
								// START CHASING PLAYER
								path_start(targetPath, maxSpeed, path_action_stop, false);
							}
						
							// TODO: Verify that this logic works
							/*var pathPointStep = 1 / path_get_number(pathToTarget);
							var pathPointNext = new Vector2(
								path_get_x(pathToTarget, path_position + pathPointStep),
								path_get_y(pathToTarget, path_position + pathPointStep)
							);
							var nearestBlockingInstance = FindNearestInstanceToPoint(pathPointNext, objBandit, id);
							if (nearestBlockingInstance != noone)
							{
								var distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
					
								if (point_distance(pathPointNext.X, pathPointNext.Y, nearestBlockingInstance.x, nearestBlockingInstance.y) <= pathBlockingRadius &&
													distanceToTarget >= distanceBlockingToTarget)
								{
									path_end();
								} else {
									nearestBlockingInstance = FindNearestInstanceToPoint(new Vector2(x, y), objBandit, id);
									distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
									if (distance_to_object(nearestBlockingInstance) <= pathBlockingRadius &&
										distanceToTarget >= distanceBlockingToTarget)
									{
										path_end();
									}	
								}
							}*/
							// RESET CHASE PATH UPDATE TIMER
							chasePathUpdateTimer.StartTimer();
						}
					}
				}
			} else {
				resumePatrolling();	
			}
		}
	} break;
	case AI_STATE.PATROL_RESUME:
	{
		if (!is_undefined(targetPath))
		{
			var distanceToPriorPoint = distance_to_point(patrolPathLastPosition.X, patrolPathLastPosition.Y);
			var distanceThreshold = 100;
			if (path_position == 1 || (distanceToPriorPoint <= distanceThreshold))
			{
				continuePatrolling();
			}
		} else {
			var distanceToPriorPoint = distance_to_point(patrolPathLastPosition.X, patrolPathLastPosition.Y);
			if (distanceToPriorPoint > (pathBlockingRadius * 2))
			{
				// CALCULATE NEW PATH TO PRIOR PATROL POINT
				path_clear_points(pathToTarget);
				if (mp_grid_path(global.ObjGridPath.roomGrid, pathToTarget, x, y, patrolPathLastPosition.X, patrolPathLastPosition.Y, true))
				{
					targetPath = pathToTarget;
					path_start(targetPath, maxSpeed, path_action_stop, false);
				}
			} else {
				continuePatrolling();	
			}
		}
		checkChaseCondition();
	} break;
	default:
	{
		if (path_position == 1) {
			path_end();
		}
	}
}

/*if (targetInstance == noone)
{
	if (targetSearchTimer.IsTimerStopped())
	{
		var nearestTarget = instance_nearest(x, y, objPlayer);
		if (instance_exists(nearestTarget))
		{
			if (!is_undefined(nearestTarget.character))
			{
				if (!nearestTarget.character.is_dead)
				{
					targetInstance = nearestTarget;
				}
			}
			// STOP TARGET SEACRH TIMER
			targetSearchTimer.StopTimer();
			// START PATH UPDATE TIMER
			chasePathUpdateTimer.StartTimer();
		} else {
			// RESET TARGET SEACRH TIMER
			targetSearchTimer.StartTimer();
		}
	} else {
		targetSearchTimer.Update();
	}
} else {
	if (!is_undefined(global.ObjGridPath.roomGrid))
	{
		if (instance_exists(targetInstance))
		{
			var distanceToTarget = point_distance(x, y, targetInstance.x, targetInstance.y);
			if (distanceToTarget <= (pathBlockingRadius * 4))
			{
				// STOP THE PATH
				path_end();
				
				if (!is_undefined(targetInstance.character))
				{
					targetInstance.character.total_hp_percent = 0;
				}
				targetInstance = noone;
				
				// STOP PATH UPDATE TIMER
				chasePathUpdateTimer.StopTimer();
				// START TARGET SEARCH TIMER
				targetSearchTimer.StartTimer();
			} else {
				if (chasePathUpdateTimer.IsTimerStopped())
				{
					if (mp_grid_path(global.ObjGridPath.roomGrid, pathToTarget, x, y, targetInstance.x, targetInstance.y, true))
					{
						path_start(pathToTarget, maxSpeed, path_action_stop, false);
					}
					
					var pathPointStep = 1 / path_get_number(pathToTarget);
					var pathPointNext = new Vector2(
						path_get_x(pathToTarget, path_position + pathPointStep),
						path_get_y(pathToTarget, path_position + pathPointStep)
					);
					var nearestBlockingInstance = FindNearestInstanceToPoint(pathPointNext, objBandit, id);
					if (nearestBlockingInstance != noone)
					{
						var distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
					
						if (point_distance(pathPointNext.X, pathPointNext.Y, nearestBlockingInstance.x, nearestBlockingInstance.y) <= pathBlockingRadius &&
											distanceToTarget >= distanceBlockingToTarget)
						{
							path_end();
						} else {
							nearestBlockingInstance = FindNearestInstanceToPoint(new Vector2(x, y), objBandit, id);
							distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
							if (distance_to_object(nearestBlockingInstance) <= pathBlockingRadius &&
								distanceToTarget >= distanceBlockingToTarget)
							{
								path_end();
							}	
						}
					}
				
					// RESET PATH UPDATE TIMER
					chasePathUpdateTimer.StartTimer();
				} else {
					chasePathUpdateTimer.Update();
				}
			}
		}
	}
}*/