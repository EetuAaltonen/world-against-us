function WorldStateHandler() constructor
{
	world_states = undefined;
	
	date_time = new WorldStateDateTime();
	date_time.day = 1;
	date_time.hours = 8;
	
	weather = 0;
	
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
	
	static Update = function()
	{
		date_time.Update();
	}
}