function CollisionLinePoint(_startPosition, _endPosition, _objectToCheck, _preciseCollisions, _notme)
{
	var collideInstance = collision_line(
		_startPosition.X, _startPosition.Y,
		_endPosition.X, _endPosition.Y,
		_objectToCheck, _preciseCollisions, _notme
	);
	var collidePosition = new Vector2(_endPosition.X, _endPosition.Y);
	if (collideInstance != noone && collideInstance.mask_index != sprNoMask) {
	    var p0 = 0;
	    var p1 = 1;
	    repeat (ceil(log2(point_distance(_startPosition.X, _startPosition.Y, _endPosition.X, _endPosition.Y))) + 1) {
	        var np = p0 + (p1 - p0) * 0.5;
	        var nx = _startPosition.X + (_endPosition.X - _startPosition.X) * np;
	        var ny = _startPosition.Y + (_endPosition.Y - _startPosition.Y) * np;
	        var px = _startPosition.X + (_endPosition.X - _startPosition.X) * p0;
	        var py = _startPosition.Y + (_endPosition.Y - _startPosition.Y) * p0;
	        var nearestCollideInstance = collision_line(px, py, nx, ny, _objectToCheck, _preciseCollisions, _notme);
	        if (nearestCollideInstance != noone && nearestCollideInstance.mask_index != sprNoMask) {
	            collideInstance = nearestCollideInstance;
				collidePosition.X = nx;
				collidePosition.Y = ny;
	            p1 = np;
	        } else {
				p0 = np;
			}
	    }
	}
	var collisionPoint = new CollisionPoint(collideInstance, collidePosition);
	return collisionPoint;
}