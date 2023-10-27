function NetworkHandler() constructor
{
	socket = undefined;
	
	client_id = UNDEFINED_UUID;
	network_status = NETWORK_STATUS.OFFLINE;
	host_address = undefined;
	host_port = undefined;
	
	preAllocNetworkBuffer = undefined;
	acknowledgment_id = -1;
	last_acknowledgment_id = 100;
	acknowledgment_timeout_timer = new Timer(TimerFromSeconds(3));
	in_flight_packets = ds_map_create();
	
	network_packet_builder = new NetworkPacketBuilder();
	network_packet_parser = new NetworkPacketParser();
	network_packet_handler = new NetworkPacketHandler();
	network_packet_queue = ds_priority_create();
	timeout_timer = new Timer(TimerFromSeconds(8));
	
	// TODO: Move these under RegionHandler
	region_id = undefined;
	room_index = undefined;
	owner_client = undefined;
	
	
	static CreateSocket = function()
	{
		var isSocketCreated = false;
		if (network_status == NETWORK_STATUS.OFFLINE)
		{
			if (!is_undefined(socket)) { DeleteSocket(); }
			socket = network_create_socket(network_socket_udp);
			preAllocNetworkBuffer = buffer_create(256, buffer_grow, 1);
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
			AddPacketToQueue(networkPacket, true);
			
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
		
		if (network_packet_builder.CreatePacket(preAllocNetworkBuffer, networkPacket))
		{
			SendPacketOverUDP();
		}
		DeleteSocket();
		
		// RESET NETWORK PROPERTIES
		client_id = UNDEFINED_UUID;
		network_status = NETWORK_STATUS.OFFLINE;
		host_address = undefined;
		host_port = undefined;
		
		acknowledgment_id = -1;
		acknowledgment_timeout_timer.running_time = 0;
		ds_map_clear(in_flight_packets);
	}
	
	static DeleteSocket = function()
	{
		buffer_delete(preAllocNetworkBuffer);
		network_destroy(socket);
	}
	
	static AddPacketToQueue = function(_networkPacket, _setAcknowledgment = false, _priority = 0)
	{
		if (!is_undefined(_networkPacket))
		{
			if (_setAcknowledgment)
			{
				show_debug_message("Pre in_flight_packets count {0}", ds_map_size(in_flight_packets));
				
				var nextAcknowledgmentId = acknowledgment_id + 1;
				if (nextAcknowledgmentId > last_acknowledgment_id) { nextAcknowledgmentId = 0; }
				if (is_undefined(in_flight_packets[? nextAcknowledgmentId]))
				{
					acknowledgment_id = nextAcknowledgmentId;
					if (ds_map_add(in_flight_packets, acknowledgment_id, _networkPacket))
					{
						_networkPacket.header.SetAcknowledgmentId(acknowledgment_id);
						ds_priority_add(network_packet_queue, _networkPacket, _priority);
						
						acknowledgment_timeout_timer.StartTimer();
					}
				} else {
					show_debug_message("Failed to add {0} to in_flight_packets, already exists", acknowledgment_id);
				}
			} else {
				ds_priority_add(network_packet_queue, _networkPacket, _priority);
			}
		}
	}
	
	static Update = function()
	{
		if (ds_priority_size(network_packet_queue) > 0)
		{
			var networkPacket = ds_priority_find_max(network_packet_queue);
			if (!is_undefined(networkPacket))
			{
				if (network_packet_builder.CreatePacket(preAllocNetworkBuffer, networkPacket))
				{
					SendPacketOverUDP();
				}
			}
			ds_priority_delete_max(network_packet_queue);
		}
		
		// RESEND ACKNOWLEDGE PACKET ON TIMEOUT
		if (acknowledgment_timeout_timer.IsTimerStopped())
		{
			var lastAcknowledgmentNetworkPacket = in_flight_packets[? acknowledgment_id];
			if (!is_undefined(lastAcknowledgmentNetworkPacket))
			{
				AddPacketToQueue(
					lastAcknowledgmentNetworkPacket,
					false /*DON'T SET ACKNOWLEDGE TWICE*/,
					lastAcknowledgmentNetworkPacket.priority
				);
				
				show_debug_message("Resending acknowledgment {0}", lastAcknowledgmentNetworkPacket.header.acknowledgment_id);
				acknowledgment_timeout_timer.StartTimer();
			}
		} else {
			acknowledgment_timeout_timer.Update();	
		}
		
		switch (network_status)
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
			AddPacketToQueue(networkPacket, true);
			
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
			AddPacketToQueue(networkPacket, true);
			
			network_status = NETWORK_STATUS.SYNC_DATA;
			timeout_timer.StartTimer();
			isSyncing = true;
		}
		return isSyncing;
	}
	
	static HandleMessage = function(_msg)
	{
		var isPacketHandled = false;
		var networkPacket = network_packet_parser.ParsePacket(_msg);
		var acknowledgmentId = networkPacket.header.acknowledgment_id;
		if (acknowledgmentId != -1)
		{
			if (!is_undefined(in_flight_packets[? acknowledgmentId]))
			{
				if (acknowledgmentId < acknowledgment_id)
				{
					show_debug_message("Old acknowledgment received {0}", acknowledgmentId);
					return isPacketHandled;
				} else {
					show_debug_message("The latest acknowledgment succesfully received {0}", acknowledgmentId);
				}
				ds_map_delete(in_flight_packets, acknowledgmentId);
			} else {
				show_debug_message("Unknown acknowledgment received {0}", acknowledgmentId);
				return isPacketHandled;
			}
		}
		
		if (!is_undefined(networkPacket))
		{
			var messageType = networkPacket.header.message_type;
			switch (messageType)
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
						if (network_packet_handler.HandlePacket(networkPacket))
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
				} break;
				case MESSAGE_TYPE.DATA_PLAYER_SYNC:
				{
					if (network_status == NETWORK_STATUS.SYNC_DATA)
					{
						network_status = NETWORK_STATUS.SESSION_IN_PROGRESS;
						room_goto(roomCamp);
						isPacketHandled = true;
					}
				} break;
				case MESSAGE_TYPE.SERVER_ERROR:
				{
					show_message(string("SERVER ERROR. Disconnecting..."));
					DisconnectSocket();
					if (room != roomMainMenu)
					{
						room_goto(roomMainMenu);
					} else {
						// OPEN MAIN MENU ROOT WINDOW
						global.GUIStateHandlerRef.ResetGUIState();
						with (objMainMenu)
						{
							event_perform(ev_other, ev_user0);
						}
					}
				} break;
				default:
				{
					// AN UNKNOWN MESSAGE TYPE
					show_debug_message(string("Received network packet with unknown message type: {0}", messageType));
				}
			}
		}
		return isPacketHandled;
	}
	
	static SendPacketOverUDP = function()
	{
		if (!is_undefined(socket))
		{
			// TODO: CALCULATE kbs
			var networkPacketSize = network_send_udp_raw(socket, host_address, host_port, preAllocNetworkBuffer, buffer_tell(preAllocNetworkBuffer));
			show_debug_message(string("Sent network packet size: {0}kb", networkPacketSize * 0.001));
		}
	}
	
	static DrawGUI = function()
	{
		if (!is_undefined(socket))
		{
			if (client_id != UNDEFINED_UUID)
			{
				draw_set_font(font_small_bold);
				draw_set_color(c_red);
				draw_set_halign(fa_right);
		
				draw_text(global.GUIW - 20, 30, string("{0} :client_id", client_id));
				draw_text(global.GUIW - 20, 50, string("{0} :Region ID", region_id ?? "Unknown"));
				draw_text(global.GUIW - 20, 70, string("{0} :Room index", room_index ?? "Unknown"));
				var ownerClientID = (owner_client ?? "Unknown");
				draw_text(global.GUIW - 20, 90, string("{0} :Region Owner", (client_id == ownerClientID) ? "Self" : "Other" ));
		
				// RESET DRAW PROPERTIES
				ResetDrawProperties();
			}
		}
	}
}