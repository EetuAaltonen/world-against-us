if (instanceState != object_index) return;

// UPDATE COLLISION BODY
if (!is_undefined(collider))
{
	collider.Update();
}

// TODO: How bullets shoud behave, not falling immediately after firing
//z = max(0, z - PHYSICS_GRAVITY);