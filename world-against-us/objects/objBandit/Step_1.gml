// INHERIT THE PARENT EVENT
event_inherited();

if (aiState == AI_STATE.QUEUE)
{
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
				// TODO: roomForest
				/*case roomForest: {
					patrolPath = pthPatrolTown;
				} break;*/
			}
		}
	
		if (!is_undefined(patrolPath))
		{
			// START PATROLLING
			targetPath = patrolPath;
			// START PATROLLING
			path_start(targetPath, maxSpeed, path_action_stop, true);
			aiState = AI_STATE.PATROL;
		} else {
			// TODO: Proper error handling
			show_message(string("No patrol path found at {0}", room_get_name(room)));
			instance_destroy();	
		}
	}
}
