// INHERIT THE PAREN EVENT
event_inherited();

if (instanceState != object_index)
{
	instanceState = event_object;
	if (!is_undefined(damageSource))
	{
		// SPEED PROPERTIES
		speed = flySpeed;
		directionalSpeedVector = new Vector2(speed, 0);
		directionalSpeedVector.Rotate(direction);
		// BULLET TRACE PROPERTIES
		bulletTraceVector = new Vector2(x, y - z);
		bulletTraceMaxLength = flySpeed;
	}
} else {
	// CHECK IF IS OUTSIDE ROOM
	if (!isHit)
	{
		// DESTROY BEYOND RANGE LIMIT
		var isOutsideRoom = (x > room_width || x < 0 || y > room_height || y < 0);
		if (isOutsideRoom)
		{
			speed = 0;
			isHit = true;
		}
	}
}