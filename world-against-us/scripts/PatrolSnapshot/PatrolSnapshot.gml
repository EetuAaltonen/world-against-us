function PatrolSnapshot(_patrolId, _routeProgress, _position) constructor
{
	patrol_id = _patrolId;
	route_progress = _routeProgress;
	position = _position;
	
	static ToJSONStruct = function()
	{
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var formatScaledPosition = scaledPosition.ToJSONStruct();
		return {
			patrol_id: patrol_id,
			route_progress: route_progress,
			position: formatScaledPosition
		}
	}
}