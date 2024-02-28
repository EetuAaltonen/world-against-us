function DebugMonitorGameHandler() constructor
{
	// GAME SAMPLING
	fps_sample_interval = 500;
	game_sample_timer = new Timer(fps_sample_interval);
	game_sample_timer.StartTimer();
	game_sample_timer.running_time += 3000; // ADD INITIAL DELAY ~3s
	
	// FPS
	fps_samples = [];
	fps_samples_max_count = 600;
	fps_samples_max_value = 1;
	
	// FPS REAL
	fps_real_samples = [];
	fps_real_samples_max_value = 1;
	
	// DELTA TIME
	delta_time_samples = [];
	delta_time_samples_max_value = 1;
	
	// MEMORY USAGE
	memory_usage_samples = [];
	memory_usage_samples_max_value = 1;
	
	static Update = function()
	{
		// UPDATE FPS SAMPLING
		game_sample_timer.Update();
		if (game_sample_timer.IsTimerStopped())
		{
			// SAMPLE FPS
			if (array_length(fps_samples) >= fps_samples_max_count) array_shift(fps_samples);
			var fpsSample = floor(fps);
			array_push(fps_samples, fpsSample);
			fps_samples_max_value = max(fpsSample, fps_samples_max_value);
			
			// SAMPLE FPS REAL
			if (array_length(fps_real_samples) >= fps_samples_max_count) array_shift(fps_real_samples);
			var fpsRealSample = floor(fps_real);
			array_push(fps_real_samples, fpsRealSample);
			fps_real_samples_max_value = max(fpsRealSample, fps_real_samples_max_value);
			
			// SAMPLE DELTA TIME
			if (array_length(delta_time_samples) >= fps_samples_max_count) array_shift(delta_time_samples);
			var deltaTimeSample = floor(delta_time);
			array_push(delta_time_samples, deltaTimeSample);
			delta_time_samples_max_value = max(deltaTimeSample, delta_time_samples_max_value);
			
			// SAMPLE MEMORY USAGE
			if (array_length(memory_usage_samples) >= fps_samples_max_count) array_shift(memory_usage_samples);
			var memoryDump = debug_event("DumpMemory", true);
			var memoryUsageSample = floor((memoryDump.totalUsed ?? 0) * 0.000001);
			array_push(memory_usage_samples, memoryUsageSample);
			memory_usage_samples_max_value = max(memoryUsageSample, memory_usage_samples_max_value);
			
			// RESTART SAMPLE TIMER
			game_sample_timer.StartTimer();
		}
	}
}