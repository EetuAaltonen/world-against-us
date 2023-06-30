// OVERRIDE INHERITED EVENT
if (initSpeed) {
	speed = flySpeed;
	traceTailStep = new Vector2(hspeed * 0.2, vspeed * 0.2);
	initSpeed = false;
}

// CHECK COLLISION
if (speed > 0 && !isHit)
{
	// DESTROY BEYOND RANGE LIMIT
	var isOutsideRoom = (x > room_width || x < 0 || y > room_height || y < 0);
	var travelledDistance = point_distance(x, y, damageSource.spawn_point.X, damageSource.spawn_point.Y);
	if (isOutsideRoom || travelledDistance > damageSource.range)
	{
		isHit = true;
		speed = 0;
	} else {
		var collisionPoint = CheckCollisionLinePoint(
			new Vector2(x, y), new Vector2(x + hspeed, y + vspeed),
			OBJECTS_TO_HIT, true, true, hitIgnoreInstance
		);
			
		if (!is_undefined(collisionPoint))
		{
			if (CheckCollisionProjectile(collisionPoint, self))
			{
				isHit = true;
			
				x = collisionPoint.position.X;
				y = collisionPoint.position.Y;
				speed = 0;
			}
		}
	}
}