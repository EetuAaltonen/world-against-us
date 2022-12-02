if (isLatencyTimerRunning)
{
	latencyTimer += delta_time * 0.001;
}
if (client.tickTimer-- <= 0)
{
	client.ResetTickTimer();
}

if (!is_undefined(client.clientId))
{
	if (client.latencyReqTimer-- <= 0)
	{
		if (!isLatencyTimerRunning)
		{
			var networkBuffer = client.CreateBuffer(MESSAGE_TYPE.LATENCY);
			buffer_write(networkBuffer, buffer_u64, current_time);
			client.SendPacketOverUDP(networkBuffer);
		} else {
			show_debug_message("Latency check took too long (" + string(client.latencyReqDelay / room_speed) + ")");
			latency = 999;
		}
		
		// Start latency timer
		latencyTimer = 0;
		isLatencyTimerRunning = true;
		client.ResetLatencyReqTimer();
	}
}
