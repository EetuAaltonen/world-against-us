function NetworkConnectionSampler() constructor
{
	ping = undefined;
	ping_interval_timer = new Timer(TimerFromSeconds(1));
	ping_timeout_timer = new Timer(TimerFromSeconds(3));
	last_update_time = 0;
	
	sent_rate_sample_timer = new Timer(TimerFromSeconds(1));
	data_sent_rate = 0;
	last_data_sent_rate = undefined;
	
	static Update = function()
	{
		// CHECK PINGING INTERVAL
		if (ping_interval_timer.IsTimerStopped())
		{
			ping_interval_timer.StopTimer();
			StartPinging();
		} else {
			ping_interval_timer.Update();
		}
		// CHECK PINGING TIMEOUT
		if (ping_timeout_timer.IsTimerStopped())
		{
			ping_timeout_timer.StopTimer();
		} else {
			ping_timeout_timer.Update();
		}
		// UPDATE DATA SAMPLE RATE
		if (sent_rate_sample_timer.IsTimerStopped())
		{
			last_data_sent_rate = data_sent_rate;
			data_sent_rate = 0;
			sent_rate_sample_timer.StartTimer();
		} else {
			sent_rate_sample_timer.Update();
		}
	}
	
	static StartPinging = function()
	{
		last_update_time = current_time;
		ping_timeout_timer.StartTimer();
		
		// PING
		var pingSample = new NetworkPingSample(last_update_time, 0);
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PING);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			pingSample,
			PACKET_PRIORITY.HIGH,
			AckTimeoutFuncPinging
		);
		if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
		{
			show_debug_message("Failed to queue PING packet");
		}
	}
	
	static StopPinging = function(lastUpdateTimeSample)
	{
		ping_timeout_timer.StopTimer();
		if (last_update_time > 0)
		{
			if (last_update_time == lastUpdateTimeSample)
			{
				ping = current_time - lastUpdateTimeSample;
			}
			last_update_time = 0;
		}
		ping_interval_timer.StartTimer();
	}
	
	static ResetNetworkConnectionSampling = function()
	{
		ping_timeout_timer.StopTimer();
		last_update_time = 0;
		ping_interval_timer.StopTimer();
		ping = undefined;
	}
}