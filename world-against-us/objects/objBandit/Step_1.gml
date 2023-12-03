// INHERIT THE PARENT EVENT
event_inherited();

if (initPath)
{
	initPath = false;
	if (is_undefined(patrolPath))
	{
		var pathLayerId = layer_get_id(LAYER_PATH_PATROL);
		if (layer_exists(pathLayerId))
		{
			// TODO: Database path 'map'
			switch(room)
			{
				case roomTown: {
					patrolPath = pthPatrolTown;
				} break;
				case roomForest: {
					patrolPath = pthPatrolForest;
				} break;
			}
		}
	}
	
	if (!is_undefined(patrolPath))
	{
		targetPath = patrolPath;
		switch (aiState)
		{
			case AI_STATE.QUEUE:
			{
				// NO START PATROLLING
				aiState = AI_STATE.PATROL;
				path_start(targetPath, maxSpeed, path_action_stop, true);
				path_position = max(0, patrolPathPercent);
			} break;
			case AI_STATE.PATROL:
			{
				path_start(targetPath, maxSpeed, path_action_stop, true);
				path_position = max(0, patrolPathPercent);
			} break;
			case AI_STATE.PATROL_RESUME:
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
	}
}
