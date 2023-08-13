function WorldStateHandler() constructor
{
	world_states = undefined;
	
	InitWorldStates();
	
	static InitWorldStates = function()
	{
		world_states = ds_map_create();
		world_states[? WORLD_STATE_UNLOCK_WALKIE_TALKIE] = false;
	}
	
	static SetWorldState = function(_worldStateIndex, _new_value)
	{
		world_states[? _worldStateIndex] = _new_value;
	}
}