// INHERIT THE PAREN EVENT
event_inherited();

// CHILD INIT
if (instanceState < INSTANCE_INIT_STATE.Done) {
	if (damageSource != undefined)
	{
		speed = flySpeed;
		instanceState = INSTANCE_INIT_STATE.Done;
	}
} else {
	// CHECK COLLISION
	if (speed > 0)
	{
		// DESTROY BEYOND RANGE LIMIT
		var isOutsideRoom = (x > room_width || x < 0 || y > room_height || y < 0);
		if (isOutsideRoom) instance_destroy();
	}
}