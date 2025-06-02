if (instanceState != object_index) return;

if (!is_undefined(skeletalAnimation)) skeletalAnimation.Update();
if (!is_undefined(collider)) collider.Update();

// TODO: How bullets shoud behave, not falling immediately after firing
//z = max(0, z - PHYSICS_GRAVITY);