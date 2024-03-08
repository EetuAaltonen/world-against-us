function FindNearestInstanceToPoint(_point, _object, _ignoreInstanceID = undefined)
{
	var nearestInstance = noone;
	var shortestDitance = undefined;
	var instanceCount = instance_number(_object);
	for (var i = 0; i < instanceCount; i++)
	{
		var instance = instance_find(_object, i);
		if (instance_exists(instance))
		{
			if (!is_undefined(_ignoreInstanceID))
			{
				if (instance.id == _ignoreInstanceID)
				{
					// SKIP IF INSTANCE ID IS IGNORE ID
					continue;	
				}
			}
			
			var distanceToPoint = point_distance(_point.X, _point.Y, instance.x, instance.y);
			if (is_undefined(shortestDitance))
			{
				nearestInstance = instance;
				shortestDitance = distanceToPoint;
			} else {
				if (distanceToPoint < shortestDitance)
				{
					nearestInstance = instance;
					shortestDitance = distanceToPoint;	
				}
			}
		}
	}
	return nearestInstance;
}