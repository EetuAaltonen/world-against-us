function Patrol(_patrol_id, _ai_state, _travel_time, _route_progress) constructor
{
	patrol_id = _patrol_id;
	ai_state = _ai_state;
	travel_time = _travel_time;
	route_progress = _route_progress;
	
	instance_ref = noone;
	local_position = new Vector2(0, 0);
	
	static ToJSONStruct = function()
	{
		var formatRouteProgress = round(ScaleFloatPercentToInt(route_progress));
		return {
			patrol_id: patrol_id,
			ai_state: ai_state,
			travel_time: travel_time,
			route_progress: formatRouteProgress
		}
	}
	
	static Update = function()
	{
		if (instance_ref != noone)
		{
			ai_state = instance_ref.aiState;
			if (ai_state == AI_STATE.PATROL)
			{
				if (instance_ref.path_index != -1)
				{
					route_progress = instance_ref.path_position;
				} else {
					route_progress = 0;
				}
			}
			local_position.X = instance_ref.x;
			local_position.Y = instance_ref.y;
		}
	}
	
	static Sync = function(_syncPatrol)
	{
		var isSynced = false;
		if (patrol_id == _syncPatrol.patrol_id)
		{
			if (instance_exists(instance_ref))
			{
				// TODO: Update instance behavior
				ai_state = _syncPatrol.ai_state;
				route_progress = _syncPatrol.route_progress;
				instance_ref.initPath = true;
				isSynced = true;
			}
		}
		return isSynced;
	}
}