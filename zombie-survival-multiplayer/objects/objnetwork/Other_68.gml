if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	if (!is_undefined(packetHeader.clientId))
	{
		switch (packetHeader.messageType)
		{
			case MESSAGE_TYPE.CONNECT_TO_HOST:
			{
				with (client)
				{
					SetClientId(packetHeader.clientId);
				}
			} break;
			case MESSAGE_TYPE.LATENCY:
			{
				// Stop latency timer
				if (isLatencyTimerRunning)
				{
					latency = latencyTimer;
					latencyTimer = 0;
					isLatencyTimerRunning = false;
				}
			} break;
		}
	}
}
