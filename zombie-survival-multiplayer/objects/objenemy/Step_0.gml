// INHERIT THE PARENT EVENT
event_inherited();

if (targetInstance == noone)
{
	targetSeekTimer.Update();
	
	if (targetSeekTimer.IsTimerStopped())
	{
		var closestTarget = instance_nearest(x, y, objPlayer);
		var distanceToTarget = point_distance(x, y, closestTarget.x, closestTarget.y);
		if (distanceToTarget <= visionRadius)
		{
			targetInstance = closestTarget;
		} else {
			targetSeekTimer.StartTimer();
		}
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
					// RESET TIMER
					pathUpdateTimer.StartTimer();
				}
			}
				
			// UPDATE TIMER
			pathUpdateTimer.Update();
		}
	}
}