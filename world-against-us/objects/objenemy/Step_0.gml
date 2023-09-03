// INHERIT THE PARENT EVENT
event_inherited();

if (targetInstance == noone)
{
	if (targetSeekTimer.IsTimerStopped())
	{
		var nearestTarget = instance_nearest(x, y, objPlayer);
		var distanceToTarget = point_distance(x, y, nearestTarget.x, nearestTarget.y);
		if (distanceToTarget <= visionRadius)
		{
			targetInstance = nearestTarget;
		} else {
			targetSeekTimer.StartTimer();
		}
	} else {
		targetSeekTimer.Update();
	}
} else {
	if (!is_undefined(global.ObjGridPath.roomGrid))
	{
		if (instance_exists(targetInstance))
		{
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
				var nearestBlockingInstance = FindNearestInstanceToPoint(pathPointNext, objEnemy, id);
				if (nearestBlockingInstance != noone)
				{
					var distanceToTarget = point_distance(x, y, targetInstance.x, targetInstance.y);
					var distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
					
					if (point_distance(pathPointNext.X, pathPointNext.Y, nearestBlockingInstance.x, nearestBlockingInstance.y) <= pathBlockingRadius &&
										distanceToTarget >= distanceBlockingToTarget)
					{
						path_end();
					} else {
						nearestBlockingInstance = FindNearestInstanceToPoint(new Vector2(x, y), objEnemy, id);
						distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
						if (distance_to_object(nearestBlockingInstance) <= pathBlockingRadius &&
							distanceToTarget >= distanceBlockingToTarget)
						{
							path_end();
						}	
					}
				}
				
				// RESET TIMER
				pathUpdateTimer.StartTimer();
			} else {
				pathUpdateTimer.Update();
			}
		}
	}
}