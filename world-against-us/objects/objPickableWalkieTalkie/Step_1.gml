// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index)
{
	instanceState = event_object;
	if (!is_undefined(global.WorldStateData))
	{
		if (global.WorldStateData[? WORLD_STATE_UNLOCK_WALKIE_TALKIE]) instance_destroy();
	}
}