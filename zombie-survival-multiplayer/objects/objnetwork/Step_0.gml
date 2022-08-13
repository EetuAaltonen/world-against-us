if (isLatencyTimerRunning)
{
	latencyTimer += delta_time * 0.001;
}

if (is_undefined(client.clientId))
{
	if (client.reconnectTimer-- <= 0)
	{
		show_debug_message("Connecting to " + string(client.hostAddress) + ":" + string(client.hostPort) + "...");
		
		client.ConnectToHost();
		client.ResetReconnectTimer();
	}
} else if (client.tickTimer-- <= 0)
{
	if (is_undefined(client.packet))
	{
		client.CreatePacket(MESSAGE_TYPE.DATA);		
		if (global.ObjPlayer != noone)
		{
			client.AddPacketContent("player_position", new Vector2(round(global.ObjPlayer.x), round(global.ObjPlayer.y)));
		}
	}
	
	if (!is_undefined(client.packet))
	{
		client.SendPacket();
	
		// Reset latency calculation
		latencyTimer = 0;
		isLatencyTimerRunning = true;
	}
}
