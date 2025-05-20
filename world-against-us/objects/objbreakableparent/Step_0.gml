// INHERIT THE PARENT EVENT
event_inherited();

// CHECK IF DESTROYED
if (collider != undefined)
{
	if (collider.collision_body != undefined)
	{
		if (collider.collision_body.is_dead)
		{
			// TODO: Do destroying trigger anything? Like explosion blast
			instance_destroy();
		}
	}
}