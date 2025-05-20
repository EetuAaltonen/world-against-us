// INHERIT THE PAREN EVENT
event_inherited();
if (instanceState != object_index)
{
	instanceState = event_object;
	if (damageSource != undefined)
	{
		speed = flySpeed;
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