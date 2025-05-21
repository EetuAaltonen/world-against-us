// INHERIT THE PAREN EVENT
event_inherited();
if (instanceState != object_index)
{
	instanceState = event_object;
	if (!is_undefined(damageSource))
	{
		speed = flySpeed;
		directionalSpeedVector = new Vector2(speed, 0);
		directionalSpeedVector.Rotate(direction);
	}
} else {
	// CHECK IF IS OUTSIDE ROOM
	if (speed > 0)
	{
		// DESTROY BEYOND RANGE LIMIT
		var isOutsideRoom = (x > room_width || x < 0 || y > room_height || y < 0);
		if (isOutsideRoom) instance_destroy();
	}
}