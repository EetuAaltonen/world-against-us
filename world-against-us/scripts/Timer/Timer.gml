function Timer(_setting_time) constructor
{
	setting_time = _setting_time; // milliseconds
	running_time = 0;
	is_timer_running = false;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
		return;
	}
	
	static StartTimer = function()
	{
		is_timer_running = true;
		running_time = setting_time;
	}
	
	static TriggerTimer = function()
	{
		is_timer_running = true;
		running_time = 0;
	}
	
	static Update = function()
	{
		if (is_timer_running)
		{
			if (running_time > 0)
			{
				running_time -= delta_time * 0.001;
				running_time = max(0, running_time);
			}
		}
	}
	
	static GetSettingTime = function()
	{
		return setting_time;
	}
	
	static GetTime = function()
	{
		return running_time;
	}
	
	 //TODO: Rename to "IsTimerTriggered"
	static IsTimerStopped = function()
	{
		return (is_timer_running && running_time <= 0);
	}
	
	static StopTimer = function()
	{
		is_timer_running = false;
	}
}