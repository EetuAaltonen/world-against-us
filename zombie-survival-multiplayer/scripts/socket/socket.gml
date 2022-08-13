function Client(_hostAddress, _hostPort) constructor
{
	hostAddress = _hostAddress;
	hostPort = _hostPort;
	
	clientId = undefined;
	packet = undefined;
	
	tickDelay = TimerRatePerSecond(30);
	tickTimer = tickDelay;
	
	reconnectDelay = TimerFromSeconds(5);
	reconnectTimer = 0;
	
	socket = network_create_socket(network_socket_udp);
	network_connect_raw(socket, hostAddress, hostPort);
	networkBuffer = buffer_create(16384, buffer_fixed, 2);
	
	static SetClientId = function(_clientId)
	{
		clientId = _clientId;
	}
	
	static ConnectToHost = function()
	{
		CreatePacket(MESSAGE_TYPE.CONNECT_TO_HOST);
		SendPacket();
	}
	
	static DisconnectFromHost = function()
	{
		CreatePacket(MESSAGE_TYPE.DISCONNECT);
		SendPacket();
	}
	
	static CreatePacket = function(_messageType)
	{
		if (!is_undefined(packet)) { show_debug_message("Packet overwrite " + string(packet.message_type) + " --> " + string(_messageType)); }
		packet = new Packet(clientId, _messageType);
	}
	
	static AddPacketContent = function(_key, _value)
	{
		packet.AddContent(_key, _value);
	}
	
	static ResetPacket = function()
	{
		packet = undefined;
	}
	
	static SendPacket = function()
	{
		if (!is_undefined(packet))
		{
			var jsonData = json_stringify(packet);
			
			buffer_seek(networkBuffer, buffer_seek_start, 0);
			buffer_write(networkBuffer, buffer_text, jsonData);
			
			network_send_udp_raw(socket, hostAddress, hostPort, networkBuffer, buffer_tell(networkBuffer));
			
			ResetPacket();
			ResetTickTimer();
		} else {
			show_debug_message("Calling undefined packet to send");
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