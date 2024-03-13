function NetworkConnectionSampler() constructor
{
	ping = undefined;
	ping_interval_timer = new Timer(1000);
	ping_timeout_timer = new Timer(3000);
	last_update_time = current_time;
	
	data_rate_sample_timer = new Timer(1000);
	data_out_rate = 0;
	last_data_out_rate = 0;
	data_in_rate = 0;
	last_data_in_rate = 0;
	
	static Update = function()
	{
		// CHECK PINGING INTERVAL
		ping_interval_timer.Update();
		if (ping_interval_timer.IsTimerStopped())
		{
			SendPingSample();
			ping_interval_timer.StartTimer();
		}
		
		// CHECK PINGING TIMEOUT
		ping_timeout_timer.Update();
		if (ping_timeout_timer.IsTimerStopped())
		{
			ping_timeout_timer.StopTimer();
			global.NetworkHandlerRef.RequestDisconnectSocket(false);
			// CONSOLE LOG
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Pinging timed out");
			// NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"Connection timed out",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
		
		// UPDATE DATA SAMPLE RATE
		data_rate_sample_timer.Update();
		if (data_rate_sample_timer.IsTimerStopped())
		{
			last_data_out_rate = data_out_rate;
			data_out_rate = 0;
			
			last_data_in_rate = data_in_rate;
			data_in_rate = 0;
			
			// DEBUG MONITOR
			var monitorHandlerRef = global.DebugMonitorNetworkHandlerRef;
			
			if (array_length(monitorHandlerRef.data_out_samples) >= monitorHandlerRef.data_out_samples_max_count) array_shift(monitorHandlerRef.data_out_samples);
			var dataOutSampleKilobits = BytesToKilobits(last_data_out_rate);
			array_push(monitorHandlerRef.data_out_samples, dataOutSampleKilobits);
			monitorHandlerRef.data_out_samples_max_value = max(dataOutSampleKilobits, monitorHandlerRef.data_out_samples_max_value);
			
			if (array_length(monitorHandlerRef.data_in_samples) >= monitorHandlerRef.data_in_samples_max_count) array_shift(monitorHandlerRef.data_in_samples);
			var dataInSampleKilobits = BytesToKilobits(last_data_in_rate);
			array_push(monitorHandlerRef.data_in_samples, dataInSampleKilobits);
			monitorHandlerRef.data_in_samples_max_value = max(dataInSampleKilobits, monitorHandlerRef.data_in_samples_max_value);
			
			data_rate_sample_timer.StartTimer();
		}
	}
	
	static StartPinging = function()
	{
		SendPingSample();
		ping_interval_timer.StartTimer();
	}
	
	static SendPingSample = function()
	{
		last_update_time = current_time;
		
		// PING
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PING);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			last_update_time,
			PACKET_PRIORITY.DEFAULT,
			undefined
		);
		
		// PREPARE AND SEND PING NETWORK PACKET
		if (!global.NetworkHandlerRef.PrepareAndSendNetworkPacket(networkPacket))
		{
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Failed to send PING network packet");
		}
		
		// START TIMEOUT TIMER
		if (!ping_timeout_timer.is_timer_running)
		{
			ping_timeout_timer.StartTimer();
		}
	}
	
	static ProcessPingSample = function(_receivedPingSample)
	{
		if (_receivedPingSample < last_update_time)
		{
			var consoleLog = string(
				"Received old ping sample {0}, expected {1}",
				_receivedPingSample,
				last_update_time
			);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
		} else {
			ping = current_time - _receivedPingSample;
			
			var monitorHandlerRef = global.DebugMonitorNetworkHandlerRef;
			if (array_length(monitorHandlerRef.ping_samples) >= monitorHandlerRef.ping_samples_max_count) array_shift(monitorHandlerRef.ping_samples);
			array_push(monitorHandlerRef.ping_samples, ping);
			monitorHandlerRef.ping_samples_max_value = max(ping, monitorHandlerRef.ping_samples_max_value);	
		}
		
		// STOP TIMEOUT TIMER
		ping_timeout_timer.StopTimer();
	}
	
	static ResetNetworkConnectionSampling = function()
	{
		// RESET PINGING
		ping = undefined;
		last_update_time = current_time;
		ping_timeout_timer.StopTimer();
		ping_interval_timer.StopTimer();
		
		// RESET DATA SEND RATE SAMPLING
		data_rate_sample_timer.StopTimer();
		data_out_rate = 0;
		last_data_out_rate = 0;
		data_in_rate = 0;
		last_data_in_rate = 0;
	}
}