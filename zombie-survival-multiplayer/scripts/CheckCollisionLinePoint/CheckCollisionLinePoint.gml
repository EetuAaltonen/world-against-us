function CheckCollisionLinePoint(_startPosition, _endPosition, _objectsToCheck, _preciseCollisions, _notme, _ignoreOwnerInstance = noone)
{
	// TODO: Bug - When aiming upward/over from above the object laser goes through it sometimes in an specific angles
	var collisionPoint = undefined;
	
	var objectToCheckCount = array_length(_objectsToCheck);
	for (var i = 0; i < objectToCheckCount; i++)
	{
		var collidePosition = new Vector2(_endPosition.X, _endPosition.Y);
		var collideInstance = noone;
		var collideInstances = ds_list_create();
		
		var collideInstanceCount = collision_line_list(
			_startPosition.X, _startPosition.Y,
			_endPosition.X, _endPosition.Y,
			_objectsToCheck[i], _preciseCollisions, _notme,
			collideInstances, true
		);
		
		for (var j = 0; j < collideInstanceCount; j++)
		{
			var instance = collideInstances[| j];
			if (instance.ownerInstance.object_index != _ignoreOwnerInstance)
			{
				collideInstance = instance;
				break;
			}
		}
		
		if (collideInstance != noone && collideInstance.mask_index != SPRITE_NO_MASK) {
			var p0 = 0;
			var p1 = 1;
			repeat (ceil(log2(point_distance(_startPosition.X, _startPosition.Y, _endPosition.X, _endPosition.Y))) + 1)
			{
				var np = p0 + (p1 - p0) * 0.5;
				var nx = _startPosition.X + (_endPosition.X - _startPosition.X) * np;
				var ny = _startPosition.Y + (_endPosition.Y - _startPosition.Y) * np;
				var px = _startPosition.X + (_endPosition.X - _startPosition.X) * p0;
				var py = _startPosition.Y + (_endPosition.Y - _startPosition.Y) * p0;
				var nearestCollideInstance = collision_line(px, py, nx, ny, _objectsToCheck[i], _preciseCollisions, _notme);
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
			
			if (collideInstance != noone)
			{
				// CHECKS THAT YOU DON'T SHOOT TARGETS BEHIND THE WALLS ETC.
				if (is_undefined(collisionPoint) ||
					(point_distance(collidePosition.X, collidePosition.Y, _startPosition.X, _startPosition.Y) < point_distance(collisionPoint.position.X, collisionPoint.position.Y, _startPosition.X, _startPosition.Y))
				)
				{
					collisionPoint = new CollisionPoint(collideInstance, collidePosition);
				}
			}
		}
	}
	
	return collisionPoint;
}