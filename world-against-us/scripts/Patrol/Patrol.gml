function Patrol(_patrol_id, _ai_state, _travel_time, _route_progress) constructor
{
	patrol_id = _patrol_id;
	ai_state = _ai_state;
	travel_time = _travel_time;
	route_progress = _route_progress;
	
	instance_ref = noone;
	
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