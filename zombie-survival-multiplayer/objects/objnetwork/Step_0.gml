if (isLatencyTimerRunning)
{
	latencyTimer += delta_time * 0.001;
}

if (is_undefined(client.clientId))
{
	if (client.reconnectTimer-- <= 0)
	{
		client.ConnectToHost();
		client.ResetReconnectTimer();
		
		// Start latency timer
		latencyTimer = 0;
		isLatencyTimerRunning = true;
	}
} else {
	// SEND ROUTINE PACKET
	if (client.tickTimer-- <= 0)
	{
		if (!is_undefined(client.routinePacket))
		{
			if (array_length(client.routinePacket.content) > 0)
			{
				client.SendRoutinePacket();
			}
		}
		client.ResetTickTimer();
	}
	
	// SEND IMPORTANT PACKET
	if (!is_undefined(client.importantPacket))
	{
		if (array_length(client.importantPacket.content) > 0)
		{
			client.SendImportantPacket();
		}
	}
}
