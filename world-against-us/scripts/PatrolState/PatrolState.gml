function PatrolState(_region_id, _patrol_id, _ai_state, _route_progress, _position, _target_network_id) constructor
{
	region_id = _region_id;
	patrol_id = _patrol_id;
	ai_state = _ai_state;
	route_progress = _route_progress;
	position = _position;
	target_network_id = _target_network_id;
	
	static ToJSONStruct = function()
	{
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var formatPosition = (!is_undefined(scaledPosition)) ? scaledPosition.ToJSONStruct() : undefined;
		return {
			region_id: region_id,	
			patrol_id: patrol_id,	
			ai_state: ai_state,
			route_progress: route_progress,
			position: formatPosition,
			target_network_id: target_network_id
		}
	}
}