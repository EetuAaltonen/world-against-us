// INHERIT THE PARENT EVENT
event_inherited();

if (targetInstance == noone)
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
			pathUpdateTimer.StartTimer();
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
				targetInstance = undefined;
				
				// STOP PATH UPDATE TIMER
				pathUpdateTimer.StopTimer();
				// START TARGET SEARCH TIMER
				targetSearchTimer.StartTimer();
			} else {
				if (pathUpdateTimer.IsTimerStopped())
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
					pathUpdateTimer.StartTimer();
				} else {
					pathUpdateTimer.Update();
				}
			}
		}
	}
}