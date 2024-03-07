// INHERIT THE PARENT EVENT
event_inherited();

aiBandit.Update();

// AI BEHAVIOUR
/*switch (aiState)
{
	case AI_STATE_BANDIT.PATROL_RETURN:
	{
		checkChaseCondition();
		
		if (aiState == AI_STATE_BANDIT.PATROL_RETURN)
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
				
					// TODO: Multiple duplicate mp_grid_path code
					if (mp_grid_path(global.ObjGridPath.roomGrid, pathToTarget, x, y, patrolPathLastPosition.X, patrolPathLastPosition.Y, true))
					{
						targetPath = pathToTarget;
						targetPosition = patrolPathLastPosition;
					
						// NETWORKING
						var patrolState = new PatrolState(
							global.NetworkRegionHandlerRef.region_id,
							patrolId, aiState,
							patrolRouteProgress,
							new Vector2(x, y),
							targetPosition
						);
						BroadcastPatrolState(patrolState);
					
						path_start(targetPath, maxSpeed, path_action_stop, false);
					}
				} else {
					continuePatrolling();	
				}
			}
		}
	} break;
	default:
	{
		if (path_position == 1) {
			// TODO: Broad cast patrol end sync
			// and make sure clients destroy related patrols locally
			path_end();
		}
	}
}

// TODO: Check if commented code below can be just removed
/*
switch (aiState)
{
	case AI_STATE_BANDIT.PATROL:
	{
		if (!is_undefined(targetPath))
		{
			if (path_position == 1) {
				path_end();
				aiState = AI_STATE_BANDIT.PATROL_END;
			} else {
				checkChaseCondition();
			}
		} else {
			path_end();
			aiState = AI_STATE_BANDIT.TRAVEL;
		}
	} break;
	case AI_STATE_BANDIT.CHASE:
	{
		if (!instance_exists(targetInstance))
		{
			resumePatrolling();
		} else {
			var targetCharacter = targetInstance.character;
			if (!is_undefined(targetCharacter))
			{
				if (!targetCharacter.IsInvulnerableState())
				{
					var targetPos = new Vector2(
						(targetInstance.bbox_left + ((targetInstance.bbox_right - targetInstance.bbox_left) * 0.5)),
						targetInstance.bbox_bottom
					);
					var distanceToTarget = point_distance(x, y, targetPos.X, targetPos.Y);
					if (distanceToTarget <= (pathBlockingRadius * 4))
					{
						targetCharacter.is_robbed = true;
						if (targetCharacter.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
						{
							global.PlayerDataHandlerRef.OnRobbed();
						}
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
								/*chasePathUpdateTimer.StartTimer();
							}
						}
					}
				} else {
					resumePatrolling();	
				}
			} else {
				resumePatrolling();		
			}
		}
	} break;
	case AI_STATE_BANDIT.PATROL_RETURN:
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
}*/

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
				
				if (!is_undefined(targetCharacter))
				{
					targetCharacter.total_hp_percent = 0;
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