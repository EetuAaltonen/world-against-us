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
		if (ping_interval_timer.IsTimerStopped())
		{
			SendPingSample();
			ping_interval_timer.StartTimer();
		} else {
			ping_interval_timer.UpdateDelta();
		}
		// CHECK PINGING TIMEOUT
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
		} else {
			ping_timeout_timer.UpdateDelta();
		}
		// UPDATE DATA SAMPLE RATE
		if (data_rate_sample_timer.IsTimerStopped())
		{
			last_data_out_rate = data_out_rate;
			data_out_rate = 0;
			
			last_data_in_rate = data_in_rate;
			data_in_rate = 0;
			
			data_rate_sample_timer.StartTimer();
		} else {
			data_rate_sample_timer.UpdateDelta();
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
			AckTimeoutFuncPinging
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
		ping = current_time - _receivedPingSample;
		if (_receivedPingSample < last_update_time)
		{
			var consoleLog = string(
				"Received old ping sample {0}, expected {1}",
				_receivedPingSample,
				last_update_time
			);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
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