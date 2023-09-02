function Timer(_setting_time) constructor
{
	setting_time = _setting_time;
	running_time = 0;
	
	static StartTimer = function()
	{
		running_time = setting_time;
	}
	
	static TriggerTimer = function()
	{
		running_time = 0;
	}
	
	static Update = function()
	{
		if (running_time > 0)
		{
			running_time = max(0, --running_time);
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
	
	static IsTimerStopped = function()
	{
		return (running_time <= 0);
	}
}