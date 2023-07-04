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
			OBJECTS_TO_HIT, true, true, hitIgnoreInstance, true
		);
			
		if (!is_undefined(collisionPoint))
		{
			var projectileCollisionPosition = CheckCollisionProjectile(collisionPoint, self);
			if (!is_undefined(projectileCollisionPosition))
			{
				isHit = true;
			
				x = projectileCollisionPosition.X;
				y = projectileCollisionPosition.Y;
				aimAngleLine.end_point.X = projectileCollisionPosition.X;
				aimAngleLine.end_point.Y = projectileCollisionPosition.Y;
				speed = 0;
			}
		} else {
			if ((abs(aimAngleLine.end_point.X - x) <= abs(hspeed)) && (abs(aimAngleLine.end_point.Y - y) <= abs(vspeed)))
			{
				isHit = true;
			
				x = aimAngleLine.end_point.X;
				y = aimAngleLine.end_point.Y;
				speed = 0;
			}
		}
	}
}