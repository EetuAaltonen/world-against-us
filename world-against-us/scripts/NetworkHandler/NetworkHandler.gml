function NetworkHandler() constructor
{
	socket = undefined;
	
	client_id = UNDEFINED_UUID;
	network_status = NETWORK_STATUS.OFFLINE;
	host_address = undefined;
	host_port = undefined;
	
	network_packet_parser = new NetworkPacketParser();
	network_packet_queue = ds_priority_create();
	timeout_timer = new Timer(TimerFromSeconds(8));
	
	static CreateSocket = function()
	{
		var isSocketCreated = false;
		if (network_status == NETWORK_STATUS.OFFLINE)
		{
			if (!is_undefined(socket)) { DeleteSocket(); }
			socket = network_create_socket(network_socket_udp);
			isSocketCreated = true;
		} else {
			// TODO: Generic error handler
			show_message("Client is already connected!");
		}
		return isSocketCreated;
	}
	
	static ConnectSocket = function(_address, _port)
	{
		var isConnecting = false;
		if (!is_undefined(socket)) {
			host_address = _address;
			host_port = _port;
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONNECT_TO_HOST, client_id);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
			AddPacketToQueue(networkPacket);
			
			isConnecting = true;
			network_status = NETWORK_STATUS.CONNECTING;
			timeout_timer.StartTimer();
		}
		return isConnecting;
	}
	
	static DisconnectSocket = function()
	{
		// FORCE DISCONNECT MESSAGE
		var packetHeader = new NetworkPacketHeader(MESSAGE_TYPE.DISCONNECT_FROM_HOST, client_id);
		var networkPacket = new NetworkPacket(packetHeader, undefined);
		var networkBuffer = WriteNetworkBuffer(networkPacket);
		
		SendPacketOverUDP(networkBuffer);
		DeleteSocket();
		
		// RESET NETWORK PROPERTIES
		client_id = UNDEFINED_UUID;
		network_status = NETWORK_STATUS.OFFLINE;
		host_address = undefined;
		host_port = undefined;
	}
	
	static DeleteSocket = function()
	{
		network_destroy(socket);
	}
	
	static AddPacketToQueue = function(_networkPacket, _priority)
	{
		if (!is_undefined(_networkPacket))
		{
			ds_priority_add(network_packet_queue, _networkPacket, _priority);
		}
	}
	
	static WriteNetworkBuffer = function(_networkPacket)
	{
		var networkBuffer = buffer_create(32, buffer_grow, 1);
		var messageType = _networkPacket.header.message_type;
		var jsonString = json_stringify(_networkPacket.payload ?? {});
		
		buffer_seek(networkBuffer, buffer_seek_start, 0);
		buffer_write(networkBuffer, buffer_u8, messageType);
		buffer_write(networkBuffer, buffer_text, client_id ?? UNDEFINED_UUID);
		buffer_write(networkBuffer, buffer_string, jsonString);
		
		return networkBuffer;
	}
	
	static Update = function()
	{
		if (ds_priority_size(network_packet_queue) > 0)
		{
			var networkPacket = ds_priority_find_max(network_packet_queue);
			if (!is_undefined(networkPacket))
			{
				var networkBuffer = WriteNetworkBuffer(networkPacket);
				// TODO: Calculate kbps and limit packet rate
				show_debug_message(string("Buffer size: {0}kb", buffer_get_size(networkBuffer) * 0.001));
				SendPacketOverUDP(networkBuffer);
			}
			ds_priority_delete_max(network_packet_queue);
		}
		
		switch(network_status)
		{
			case NETWORK_STATUS.CONNECTING:
			{
				if (timeout_timer.IsTimerStopped())
				{
					network_status = NETWORK_STATUS.OFFLINE;
					if (global.GUIStateHandlerRef.CloseCurrentGUIState())
					{
						show_message("Connecting timed out :(");
					}
					// RESET TIMEOUT TIMER
					timeout_timer.running_time = 0;
				} else {
					timeout_timer.Update();
					
					// UPDATE TIMEOUT TEXT
					var connectWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuConnect);
					if (!is_undefined(connectWindow))
					{
						var timeoutTitle = connectWindow.GetChildElementById("TimeoutTimerTitle");
						if (!is_undefined(timeoutTitle))
						{
							var time = TimerFromFrames(global.NetworkHandlerRef.timeout_timer.GetTime());
							timeoutTitle.text = string("Timeout in {0}s", ceil(time));
						}
					}
				}
			} break;
			case NETWORK_STATUS.JOINING_TO_GAME:
			{
				if (timeout_timer.IsTimerStopped())
				{
					network_status = NETWORK_STATUS.TIMED_OUT;
					DisconnectSocket();
					room_goto(roomMainMenu);
				} else {
					timeout_timer.Update();
				}
			} break;
			case NETWORK_STATUS.SYNC_DATA:
			{
				if (timeout_timer.IsTimerStopped())
				{
					network_status = NETWORK_STATUS.TIMED_OUT;
					DisconnectSocket();
					room_goto(roomMainMenu);
				} else {
					timeout_timer.Update();
				}
			} break;
			case NETWORK_STATUS.PINGING:
			{
				if (timeout_timer.IsTimerStopped())
				{
					// TODO: Time out pinging
					network_status = NETWORK_STATUS.TIMED_OUT;
					DisconnectSocket();
					room_goto(roomMainMenu);
				} else {
					timeout_timer.Update();
				}
			} break;
		}
	}
	
	static RequestJoinGame = function()
	{
		var isJoining = false;
		if (!is_undefined(socket)) {
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_JOIN_GAME, client_id);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
			AddPacketToQueue(networkPacket);
			
			network_status = NETWORK_STATUS.JOINING_TO_GAME;
			timeout_timer.StartTimer();
			isJoining = true;
		}
		return isJoining;
	}
	
	static SyncPlayerData = function(_playerCharacterData)
	{
		var isSyncing = false;
		if (!is_undefined(socket)) {
			// TODO: If there is some data to be syncronized
			//var jsonPlayerData = _playerCharacterData.ToJSONStruct();
			//var jsonPlayerBackpackData = _playerCharacterData.backpack.ToJSONStruct();
			
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.DATA_PLAYER_SYNC, client_id);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined/*jsonPlayerData / jsonPlayerBackpackData*/);
			AddPacketToQueue(networkPacket);
			
			network_status = NETWORK_STATUS.SYNC_DATA;
			timeout_timer.StartTimer();
			isSyncing = true;
		}
		return isSyncing;
	}
	
	static HandlePacket = function(_msg)
	{
		var isPacketHandled = false;
		var networkPacket = network_packet_parser.ParsePacket(_msg);
		if (!is_undefined(networkPacket))
		{
			var messageType = networkPacket.header.message_type;
			switch(messageType)
			{
				case MESSAGE_TYPE.CONNECT_TO_HOST:
				{
					if (network_status == NETWORK_STATUS.CONNECTING)
					{
						// CLOSE CONNECT WINDOW
						if (global.GUIStateHandlerRef.CloseCurrentGUIState())
						{
							// SET NEW CLIENT ID AND NETWORK STATUS
							client_id = networkPacket.header.client_id;
							network_status = NETWORK_STATUS.CONNECTED;
							
							// OPEN SAVE SELECTION
							var mainMenuMultiplayerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuMultiplayer);
							if (!is_undefined(mainMenuMultiplayerWindow))
							{
								if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.SaveSelection, [GAME_WINDOW.MainMenuSaveSelection]))
								{
									global.GameWindowHandlerRef.OpenWindowGroup([
										CreateWindowMainMenuSaveSelection(GAME_WINDOW.MainMenuSaveSelection, mainMenuMultiplayerWindow.zIndex - 1, OnClickMenuMultiplayerPlay)
									]);
								}
							}
						}
						// RESET TIMEOUT TIMER
						timeout_timer.running_time = 0;
						
						isPacketHandled = true;
					}
				} break;
				case MESSAGE_TYPE.REQUEST_JOIN_GAME:
				{
					if (network_status == NETWORK_STATUS.JOINING_TO_GAME)
					{
						var gameSaveData = global.GameSaveHandlerRef.game_save_data;
						if (!is_undefined(gameSaveData))
						{
							if (gameSaveData.isSaveLoadingFirstTime)
							{
								if (!is_undefined(gameSaveData.player_data))
								{
									if (!is_undefined(gameSaveData.player_data.character))
									{
										SyncPlayerData(gameSaveData.player_data.character);
									}
								}
							}
						}
						isPacketHandled = true;
					}
				}
				case MESSAGE_TYPE.DATA_PLAYER_SYNC:
				{
					if (network_status == NETWORK_STATUS.SYNC_DATA)
					{
						network_status = NETWORK_STATUS.SESSION_IN_PROGRESS;
						room_goto(roomCamp);
						isPacketHandled = true;
					}
				}
				default:
				{
					// AN UNKNOWN MESSAGE TYPE
					show_debug_message(string("Received network packet with unknown message type: {0}", messageType));
				}
			}
		}
		return isPacketHandled;
	}
	
	static SendPacketOverUDP = function(_networkBuffer)
	{
		if (!is_undefined(socket))
		{
			network_send_udp_raw(socket, host_address, host_port, _networkBuffer, buffer_tell(_networkBuffer));
			buffer_delete(_networkBuffer);
		}
	}
}