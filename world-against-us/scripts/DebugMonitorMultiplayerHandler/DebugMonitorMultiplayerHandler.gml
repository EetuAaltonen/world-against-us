function DebugMonitorMultiplayerHandler() constructor
{
	// NETWORK ENTITIES
	network_entities_samples = [];
	network_entities_samples_max_count = 300;
	network_entities_samples_max_value = 1;
	network_entities_sample_interval = 2000;
	network_entities_sample_timer = new Timer(network_entities_sample_interval);
	network_entities_sample_timer.StartTimer();
	
	// FAST TRAVEL TIME
	fast_travel_time_samples = [];
	fast_travel_time_samples_max_count = 100;
	fast_travel_time_samples_max_value = 1;
	fast_travel_sample_start_time = 0;
	
	static Update = function()
	{
		// UPDATE NETWORK ENTITY SAMPLING
		network_entities_sample_timer.Update();
		if (network_entities_sample_timer.IsTimerStopped())
		{
			// SAMPLE NETWORK ENTITY COUNT
			var networkEntityCount = 0;
			var regionHandler = global.NetworkRegionObjectHandlerRef;
			// LOCAL INSTANCE OBJECTS
			if (instance_exists(global.InstancePlayer)) networkEntityCount++;
			var localPlayers = regionHandler.local_players;
			if (!is_undefined(localPlayers)) networkEntityCount += ds_list_size(localPlayers);
			var localPatrols = regionHandler.local_patrols;
			if (!is_undefined(localPatrols)) networkEntityCount += ds_list_size(localPatrols);
			if (!is_undefined(regionHandler.scouting_drone)) networkEntityCount++;
			// CONTAINERS
			if (!is_undefined(regionHandler.requested_container_access)) networkEntityCount++;
			// SCOUTING STREAM
			var mapDataHandler = global.MapDataHandlerRef;
			if (!is_undefined(mapDataHandler.active_operations_scout_stream))
			{
				// OPERATIONS CENTER INSTANCE
				networkEntityCount++;
				// SCOUTING DRONE
				if (!is_undefined(mapDataHandler.scouting_drone)) networkEntityCount++;
				// MONITORED INSTANCE OBJECTS
				if (!is_undefined(mapDataHandler.dynamic_map_data)) networkEntityCount += ds_list_size(mapDataHandler.dynamic_map_data);
			}
			
			if (array_length(network_entities_samples) >= network_entities_samples_max_count) array_shift(network_entities_samples);
			array_push(network_entities_samples, networkEntityCount);
			network_entities_samples_max_value = max(networkEntityCount, network_entities_samples_max_value);
				
			// RESTART SAMPLE TIMER
			network_entities_sample_timer.StartTimer();
		}
	}
	
	
	static StartFastTravelTimeSampling = function()
	{
		fast_travel_sample_start_time = current_time;	
	}
	
	static EndFastTravelTimeSampling = function()
	{
		if (array_length(fast_travel_time_samples) >= fast_travel_time_samples_max_count) array_shift(fast_travel_time_samples);
		var fastTravelTimeSample = floor(current_time - fast_travel_sample_start_time);
		array_push(fast_travel_time_samples, fastTravelTimeSample);
		fast_travel_time_samples_max_value = max(fastTravelTimeSample, fast_travel_time_samples_max_value);
		fast_travel_sample_start_time = 0;
	}
	
	static ResetMultiplayerDebugMonitoring = function()
	{
		// NETWORK ENTITIES
		network_entities_samples = [];
		network_entities_samples_max_value = 1;
		
		// FAST TRAVEL TIME
		fast_travel_time_samples = [];
		fast_travel_time_samples_max_value = 1;
		fast_travel_sample_start_time = 0;
	}
}