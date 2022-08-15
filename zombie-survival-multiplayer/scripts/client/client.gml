function Client(_hostAddress, _hostPort) constructor
{
	hostAddress = _hostAddress;
	hostPort = _hostPort;
	
	clientId = undefined;
	
	// PACKETS
	importantPacket = undefined;
	routinePacket = undefined;
	
	tickDelay = TimerRatePerSecond(30);
	tickTimer = tickDelay;
	rollbackThreshold = 800; // Time in ms
	
	reconnectDelay = TimerFromSeconds(5);
	reconnectTimer = 0;
	
	socket = network_create_socket(network_socket_udp);
	network_connect_raw(socket, hostAddress, hostPort);
	
	static SetClientId = function(_clientId)
	{
		clientId = _clientId;
	}
	
	static ConnectToHost = function()
	{
		var connectPacket = CreatePacket(MESSAGE_TYPE.CONNECT_TO_HOST);
		
		connectPacket.AddContent("player_data", new PlayerData(
			clientId,
			new Vector2(global.ObjPlayer.x, global.ObjPlayer.y),
			new Vector2(global.ObjPlayer.hSpeed, global.ObjPlayer.vSpeed),
			new InputMap(
				global.ObjPlayer.key_up,
				global.ObjPlayer.key_down,
				global.ObjPlayer.key_left,
				global.ObjPlayer.key_right
			)
		));
		
		SendPacketOverUDP(connectPacket);
	}
	
	static DisconnectFromHost = function()
	{
		var disconnectPacket = CreatePacket(MESSAGE_TYPE.DISCONNECT_FROM_HOST);
		SendPacketOverUDP(disconnectPacket);
		
		// RESET PACKETS
		importantPacket = undefined;
		routinePacket = undefined;
	}
	
	static CreatePacket = function(_messageType)
	{
		return new Packet(clientId, _messageType);
	}
	
	static SendPacketOverUDP = function(_packet)
	{
		var jsonData = json_stringify(_packet);
		var networkBuffer = buffer_create(16384, buffer_fixed, 2);
		
		buffer_seek(networkBuffer, buffer_seek_start, 0);
		buffer_write(networkBuffer, buffer_text, jsonData);
			
		network_send_udp_raw(socket, hostAddress, hostPort, networkBuffer, buffer_tell(networkBuffer));
		buffer_delete(networkBuffer);
	}
	
	static SendRoutinePacket = function()
	{
		if (!is_undefined(routinePacket))
		{
			SendPacketOverUDP(routinePacket);
			routinePacket = new Packet(clientId, MESSAGE_TYPE.DATA);
			ResetTickTimer();
		} else {
			show_debug_message("Calling undefined routine packet to send");
		}	
	}
	
	static SendImportantPacket = function()
	{
		if (!is_undefined(importantPacket))
		{
			SendPacketOverUDP(importantPacket);
			importantPacket = new Packet(clientId, MESSAGE_TYPE.DATA);
		} else {
			show_debug_message("Calling undefined important packet to send");
		}	
	}
	
	static ResetTickTimer = function()
	{
		tickTimer = tickDelay;
	}
	
	static ResetReconnectTimer = function()
	{
		reconnectTimer = reconnectDelay--;
	}
}