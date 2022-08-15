if (async_load[? "size"] > 0)
{
	// Stop latency timer
	if (isLatencyTimerRunning)
	{
		latency = latencyTimer;
		latencyTimer = 0;
		isLatencyTimerRunning = false;
	}
	
	var data = DecodeBuffer(async_load[? "buffer"]);
	var clientId = data[$ "client_id"];
	
	switch (data[$ "message_type"])
	{
		case MESSAGE_TYPE.CONNECT_TO_HOST:
		{
			if (!is_undefined(clientId))
			{
				with (client)
				{
					SetClientId(clientId);
				
					// RESET PACKETS
					importantPacket = new Packet(clientId, MESSAGE_TYPE.DATA);
					routinePacket = new Packet(clientId, MESSAGE_TYPE.DATA);
				}
			}
		} break;
	}
}
