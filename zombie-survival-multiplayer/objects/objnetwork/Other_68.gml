/*if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	if (!is_undefined(packetHeader.clientId))
	{
		switch (packetHeader.messageType)
		{
			case MESSAGE_TYPE.CONNECT_TO_HOST:
			{
				if (client.isConnecting)
				{
					if (room == roomMainMenu)
					{
						if (!is_undefined(packetHeader.clientId))
						{
							client.SetClientId(packetHeader.clientId);
							room_goto(roomPrologue);
						}
					}
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
}*/
