function CheckCollisionLinePoint(_startPosition, _stepEndPosition, _objectsToCheck, _preciseCollisions, _notme, _ignoreOwnerInstance = noone, _priorityHighlightedTarget = false)
{
	// TODO: Bug - When aiming upward/over from above the object laser goes through it sometimes in an specific angles
	var finaleCollisionPoint = undefined;
	
	var objectToCheckCount = array_length(_objectsToCheck);
	for (var i = 0; i < objectToCheckCount; i++)
	{
		var collidePosition = _stepEndPosition.Clone();
		var collideInstance = noone;
		var collideInstances = ds_list_create();
		
		var collideInstanceCount = collision_line_list(
			_startPosition.X, _startPosition.Y,
			_stepEndPosition.X, _stepEndPosition.Y,
			_objectsToCheck[i], _preciseCollisions, _notme,
			collideInstances, true
		);
		
		// CHECK 6 THE MOST CLOSEST TARGETS
		var instanceCountToCheck = (_priorityHighlightedTarget && global.HighlightHandlerRef.highlightedTarget != noone) ? collideInstanceCount : min(6, collideInstanceCount);
		
		for (var j = 0; j < instanceCountToCheck; j++)
		{
			var nextClosestInstance = collideInstances[| j];
			if (nextClosestInstance.ownerInstance.object_index != _ignoreOwnerInstance && nextClosestInstance.mask_index != SPRITE_NO_MASK)
			{
				if (collideInstance == noone)
				{
					collideInstance = nextClosestInstance;
				} else {
					// CHECK THE NEXT CLOSESTS TARGET
					if (_priorityHighlightedTarget && global.HighlightHandlerRef.highlightedTarget != noone)
					{
						if (collideInstance.ownerInstance != global.HighlightHandlerRef.highlightedTarget)
						{
							if (nextClosestInstance.ownerInstance == global.HighlightHandlerRef.highlightedTarget)
							{
								collideInstance = nextClosestInstance;
								break;
							}
						}
					} else {
						if (abs(nextClosestInstance.y - _startPosition.Y) < abs(collideInstance.y - _startPosition.Y))
						{
							collideInstance = nextClosestInstance;
						}
					}
				}
			}
		}
		// DESTROY TEMP COLLIDE INSTANCE DS LIST
		DestroyDSListAndDeleteValues(collideInstances);
		
		if (collideInstance != noone) {
			if (!_priorityHighlightedTarget || (_priorityHighlightedTarget && (global.HighlightHandlerRef.highlightedTarget == collideInstance.ownerInstance || global.HighlightHandlerRef.highlightedTarget == noone)))
			{
				var p0 = 0;
				var p1 = 1;
				repeat (ceil(log2(point_distance(_startPosition.X, _startPosition.Y, _stepEndPosition.X, _stepEndPosition.Y))) + 1)
				{
					var np = p0 + (p1 - p0) * 0.5;
					var nx = _startPosition.X + (_stepEndPosition.X - _startPosition.X) * np;
					var ny = _startPosition.Y + (_stepEndPosition.Y - _startPosition.Y) * np;
					var px = _startPosition.X + (_stepEndPosition.X - _startPosition.X) * p0;
					var py = _startPosition.Y + (_stepEndPosition.Y - _startPosition.Y) * p0;
					var nearestCollideInstance = collision_line(px, py, nx, ny, collideInstance, _preciseCollisions, _notme);
					if (nearestCollideInstance != noone)
					{
						if (nearestCollideInstance.ownerInstance.object_index != _ignoreOwnerInstance && nearestCollideInstance.mask_index != SPRITE_NO_MASK)
						{
							collideInstance = nearestCollideInstance;
							collidePosition.X = nx;
							collidePosition.Y = ny;
							p1 = np;
						} else {
							p0 = np;
						}
					} else {
						p0 = np;
					}
				}
			
				// CHECKS THAT YOU DON'T SHOOT TARGETS BEHIND THE WALLS ETC.
				if (collideInstance != noone)
				{
					finaleCollisionPoint = new CollisionPoint(collideInstance, collidePosition);
				}
			}
		}
	}
	
	return finaleCollisionPoint;
}