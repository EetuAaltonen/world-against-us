function NetworkHandler() constructor
{
	socket = undefined;
	
	client_id = UNDEFINED_UUID;
	network_status = NETWORK_STATUS.OFFLINE;
	host_address = undefined;
	host_port = undefined;
	
	preAllocNetworkBuffer = undefined;
	
	network_packet_builder = new NetworkPacketBuilder();
	network_packet_parser = new NetworkPacketParser();
	network_packet_handler = new NetworkPacketHandler();
	network_packet_tracker = new NetworkPacketTracker();
	network_packet_queue = ds_priority_create();
	timeout_timer = new Timer(TimerFromSeconds(8));
	
	network_region_handler = new NetworkRegionHandler();
	
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
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONNECT_TO_HOST);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
			if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
			{
				if (AddPacketToQueue(networkPacket))
				{
					network_status = NETWORK_STATUS.CONNECTING;
					timeout_timer.StartTimer();
					isConnecting = true;
				} else {
					show_debug_message("Failed to connect socket");
				}
			}
		}
		return isConnecting;
	}
	
	static DisconnectSocket = function()
	{
		// FORCE DISCONNECT MESSAGE IF ONLINE
		if (global.MultiplayerMode)
		{
			var packetHeader = new NetworkPacketHeader(MESSAGE_TYPE.DISCONNECT_FROM_HOST);
			var networkPacket = new NetworkPacket(packetHeader, undefined);
		
			if (network_packet_builder.CreatePacket(preAllocNetworkBuffer, networkPacket))
			{
				SendPacketOverUDP();
			}
		}
		DeleteSocket();
		
		// RESET NETWORK PROPERTIES
		client_id = UNDEFINED_UUID;
		network_status = NETWORK_STATUS.OFFLINE;
		host_address = undefined;
		host_port = undefined;
		
		// CLEAR IN FLIGHT NETWORK PACKET TRACKING
		network_packet_tracker.ResetNetworkPacketTracking();
		
		// RESET REGION DATA
		network_region_handler.ResetRegionData();
		
		global.MultiplayerMode = false;
	}
	
	static DeleteSocket = function()
	{
		buffer_delete(preAllocNetworkBuffer);
		network_destroy(socket);
	}
	
	static AddPacketToQueue = function(_networkPacket)
	{
		var isAddedToQueue = false;
		if (!is_undefined(_networkPacket))
		{
			ds_priority_add(network_packet_queue, _networkPacket, _networkPacket.priority);
			isAddedToQueue = true;
		} else {
			show_debug_message("Failed to add 'undefined' network packet to queue");
		}
		return isAddedToQueue;
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
		network_packet_tracker.UpdateInFlightNetworkPackets();
		
		// TODO: Time out pinging
	}
	
	static RequestJoinGame = function()
	{
		var isJoining = false;
		if (!is_undefined(socket)) {
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_JOIN_GAME);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
			if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
			{
				if (AddPacketToQueue(networkPacket))
				{
					network_status = NETWORK_STATUS.JOINING_TO_GAME;
					timeout_timer.StartTimer();
					isJoining = true;
				}
			}
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
			
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.DATA_PLAYER_SYNC);
			var networkPacket = new NetworkPacket(networkPacketHeader, undefined/*jsonPlayerData / jsonPlayerBackpackData*/);
			if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
			{
				if (AddPacketToQueue(networkPacket))
				{
					network_status = NETWORK_STATUS.SYNC_DATA;
					timeout_timer.StartTimer();
					isSyncing = true;
				}
			}
		}
		return isSyncing;
	}
	
	static HandleMessage = function(_msg)
	{
		var isPacketHandled = false;
		var networkPacket = network_packet_parser.ParsePacket(_msg);
		if (network_packet_tracker.CheckNetworkPacketAcknowledgment(networkPacket))
		{
			if (!is_undefined(networkPacket))
			{
				var messageType = networkPacket.header.message_type;
				switch (messageType)
				{
					case MESSAGE_TYPE.CONNECT_TO_HOST:
					{
						if (network_status == NETWORK_STATUS.CONNECTING)
						{
							// SET NETWORK PROPERTIES
							client_id = networkPacket.header.client_id;
							network_status = NETWORK_STATUS.CONNECTED;
							global.MultiplayerMode = true;
						
							// CLOSE CONNECT WINDOW
							if (global.GUIStateHandlerRef.CloseCurrentGUIState())
							{
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
						var errorMessage = networkPacket.payload[$ "error"] ?? "Unknown";
						show_message(string("SERVER ERROR: {0} Disconnecting...", errorMessage));
						// SET MULTIPLAYER MODE FALSE TO AVOID SENDING FURTHER DISCONNECT PACKET
						global.MultiplayerMode = false;
						DisconnectSocket();
						if (room != roomMainMenu)
						{
							room_goto(roomMainMenu);
						} else {
							// RESET GUI STATE MAIN MENU
							if (!global.GUIStateHandlerRef.ResetGUIStateMainMenu())
							{
								show_debug_message("Failed to reset GUI state Main Menu");
							}
						}
						isPacketHandled = true;
					} break;
					default:
					{
						isPacketHandled = network_packet_handler.HandlePacket(networkPacket);
						if (!isPacketHandled)
						{
							show_debug_message(string("Unable to handle message type: {0}", messageType));
						}
					}
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
		draw_set_font(font_small_bold);
		draw_set_color(c_red);
		draw_set_halign(fa_right);
		
		draw_text(global.GUIW - 20, 10, string("{0} :Status", global.MultiplayerMode ? "Online" : "Offline"));
		
		if (!is_undefined(socket))
		{
			if (client_id != UNDEFINED_UUID)
			{
				draw_text(global.GUIW - 20, 30, string("{0} :client_id", client_id));
				draw_text(global.GUIW - 20, 50, string("{0} :Region ID", network_region_handler.region_id ?? "Unknown"));
				draw_text(global.GUIW - 20, 70, string("{0} :Room index", network_region_handler.room_index ?? "Unknown"));
				var ownerClientID = (network_region_handler.owner_client ?? "Unknown");
				draw_text(global.GUIW - 20, 90, string("{0} :Region Owner", (client_id == ownerClientID) ? "Self" : "Other"));
			}
		}
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}