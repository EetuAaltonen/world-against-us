// INHERIT THE PARENT EVENT
event_inherited();

// CHECK IF DESTROYED
if (!is_undefined(collider))
{
	if (!is_undefined(collider.collision_body))
	{
		if (collider.collision_body.state == COLLISION_BODY_STATE.DEAD)
		{
			// TODO: Do destroying trigger anything? Like explosion blast
			instance_destroy();
		}
	}
}