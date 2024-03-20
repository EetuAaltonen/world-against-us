function DebugMonitorGameHandler() constructor
{
	// GAME SAMPLING
	fps_sample_interval = 500; // ms
	game_sample_timer = new Timer(fps_sample_interval);
	game_sample_timer.StartTimer();
	game_sample_timer.running_time += 3000; // ADD INITIAL DELAY ~3s
	
	// FPS
	fps_samples = [];
	fps_samples_max_count = 1200;
	fps_samples_max_value = 1;
	
	// FPS REAL
	fps_real_samples = [];
	fps_real_samples_max_value = 1;
	
	// DELTA TIME
	delta_time_samples = [];
	delta_time_samples_max_value = 1;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
		return;
	}
	
	static Update = function()
	{
		// UPDATE FPS SAMPLING
		game_sample_timer.Update();
		if (game_sample_timer.IsTimerStopped())
		{
			// SAMPLE FPS
			if (array_length(fps_samples) >= fps_samples_max_count) array_shift(fps_samples);
			var fpsSample = max(0, floor(fps));
			array_push(
				fps_samples,
				new DebugMonitorSample(current_time, fpsSample)
			);
			fps_samples_max_value = max(fpsSample, fps_samples_max_value);
			
			// SAMPLE FPS REAL
			if (array_length(fps_real_samples) >= fps_samples_max_count) array_shift(fps_real_samples);
			var fpsRealSample = max(0, floor(fps_real));
			array_push(
				fps_real_samples,
				new DebugMonitorSample(current_time, fpsRealSample)
			);
			fps_real_samples_max_value = max(fpsRealSample, fps_real_samples_max_value);
			
			// SAMPLE DELTA TIME
			if (array_length(delta_time_samples) >= fps_samples_max_count) array_shift(delta_time_samples);
			var deltaTimeSample = max(0, floor(delta_time));
			array_push(
				delta_time_samples,
				new DebugMonitorSample(current_time, deltaTimeSample)
			);
			delta_time_samples_max_value = max(deltaTimeSample, delta_time_samples_max_value);
			
			// RESTART SAMPLE TIMER
			game_sample_timer.StartTimer();
		}
	}
	
	GetMaxFpsSamplesValue = function()
	{
		return fps_samples_max_value;
	}
	
	GetMaxFpsRealSamplesValue = function()
	{
		return fps_real_samples_max_value;
	}
	
	GetMaxDeltaTimeSamplesValue = function()
	{
		return delta_time_samples_max_value;
	}
}