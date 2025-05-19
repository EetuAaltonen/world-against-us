if (instanceState < INSTANCE_INIT_STATE.Done) return;

// UPDATE COLLISION BODY
if (collider != undefined)
{
	collider.Update();
}

// TODO: How bullets shoud behave, not falling immediately after firing
//z = max(0, z - PHYSICS_GRAVITY);