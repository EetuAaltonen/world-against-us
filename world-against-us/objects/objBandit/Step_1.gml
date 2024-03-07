// INHERIT THE PARENT EVENT
event_inherited();
	
// TODO: Fix sync code
// locate this logic somewhere else
/*if (!is_undefined(patrolPath))
{
	switch (aiState)
	{
		case AI_STATE_BANDIT.TRAVEL:
		{
			// NO START PATROLLING
			aiState = AI_STATE_BANDIT.PATROL;
			targetPath = patrolPath;
			path_start(targetPath, maxSpeed, path_action_stop, true);
			path_position = max(0, patrolRouteProgress);
		} break;
		case AI_STATE_BANDIT.PATROL:
		{
			targetPath = patrolPath;
			path_start(targetPath, maxSpeed, path_action_stop, true);
			path_position = max(0, patrolRouteProgress);
		} break;
		case AI_STATE_BANDIT.CHASE:
		{
			if (!global.NetworkRegionHandlerRef.IsClientRegionOwner())
			{
				if (!is_undefined(targetPosition))
				{
					// CALCULATE NEW PATH TO TARGET
					path_clear_points(pathToTarget);

					if (mp_grid_path(global.ObjGridPath.roomGrid, pathToTarget, x, y, targetPosition.X, targetPosition.Y, true))
					{
						targetPath = pathToTarget;
						// START CHASING PLAYER
						//path_start(targetPath, maxSpeed, path_action_stop, false);
					}
				}
			}
		} break;
		case AI_STATE_BANDIT.PATROL_RETURN:
		{
			// TODO: Sync current location without path_start call
			// Because it would teleport him straight onto path
			// and doesn't keep the resume path
		} break;
	}
} else {
	// TODO: Proper error handling
	show_message(string("No patrol path found at {0}", room_get_name(room)));
	instance_destroy();	
}*/