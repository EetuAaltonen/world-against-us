function WorldStateHandler() constructor
{
	world_states = undefined;
	
	InitWorldStates();
	
	static InitWorldStates = function()
	{
		world_states = ds_map_create();
		world_states[? WORLD_STATE_UNLOCK_WALKIE_TALKIE] = false;
	}
}