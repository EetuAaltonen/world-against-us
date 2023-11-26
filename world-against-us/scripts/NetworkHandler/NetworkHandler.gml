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
	
	static OnRoomStart = function()
	{
		// VALIDATE CONTAINERS
		if (!network_region_handler.network_region_object_handler.ValidateRegionContainers())
		{
			show_message("Error occured during OnRoomStart");
			DisconnectSocket();
			if (room != roomMainMenu)
			{
				room_goto(roomMainMenu);
			}
		}
		
		// REQUEST REGION SYNC
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_INSTANCE);
		var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
		if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
		{
			if (!AddPacketToQueue(networkPacket))
			{
				show_debug_message("Failed to add 'sync instance' packet to queue");
			}
		}
	}
	
	static OnRoomEnd = function()
	{
		network_region_handler.OnRoomEnd();
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
		
		// CHECK GAME OVER WINDOW
		if (room != roomMainMenu && room != roomCamp && room != roomLoadResources)
		{
			if (!is_undefined(global.PlayerCharacter))
			{
				if (global.PlayerCharacter.is_dead)
				{
					// CHECK IF NOT IN FAST TRAVEL QUEUE
					var fastTravelQueueWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.WorldMapFastTravelQueue);
					if (is_undefined(fastTravelQueueWindow))
					{
						// CHECK IF NOT GAME OVER WINDOW SHOWING
						var gameOverWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.GameOver);
						if (is_undefined(gameOverWindow))
						{
							// DELETE ALL ITEMS
							global.PlayerBackpack.ClearAllItems();
							
							// OPEN MAP
							var guiState = new GUIState(
								GUI_STATE.GameOver, undefined, undefined,
								[GAME_WINDOW.GameOver], GUI_CHAIN_RULE.OverwriteAll,
								undefined, undefined
							);
							if (global.GUIStateHandlerRef.RequestGUIState(guiState))
							{
								global.GameWindowHandlerRef.OpenWindowGroup([
									CreateWindowGameOver(GAME_WINDOW.GameOver, -1)
								]);
							}
						}
					}
				}
			}
		}
		
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
					isJoining = true;
				}
			}
		}
		return isJoining;
	}
	
	static HandleMessage = function(_msg)
	{
		var isMessageHandled = false;
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
							isMessageHandled = true;
						}
					} break;
					case MESSAGE_TYPE.REQUEST_JOIN_GAME:
					{
						if (network_status == NETWORK_STATUS.JOINING_TO_GAME)
						{
							if (network_packet_handler.HandlePacket(networkPacket))
							{
								var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_WORLD_STATE);
								var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
								if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
								{
									if (AddPacketToQueue(networkPacket))
									{
										network_status = NETWORK_STATUS.SYNC_WORLD_STATE;
										isMessageHandled = true;
									}
								}
							}
						}
					} break;
					case MESSAGE_TYPE.SYNC_WORLD_STATE:
					{
						if (network_status == NETWORK_STATUS.SYNC_WORLD_STATE)
						{
							if (network_packet_handler.HandlePacket(networkPacket))
							{
								var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.DATA_PLAYER_SYNC);
								var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
								if (network_packet_tracker.SetNetworkPacketAcknowledgment(networkPacket))
								{
									if (AddPacketToQueue(networkPacket))
									{
										network_status = NETWORK_STATUS.SYNC_DATA;
										isMessageHandled = true;
									}
								}
							}
						}
					} break;
					case MESSAGE_TYPE.DATA_PLAYER_SYNC:
					{
						if (network_status == NETWORK_STATUS.SYNC_DATA)
						{
							network_status = NETWORK_STATUS.SESSION_IN_PROGRESS;
							room_goto(roomCamp);
							isMessageHandled = true;
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
						isMessageHandled = true;
					} break;
					default:
					{
						isMessageHandled = network_packet_handler.HandlePacket(networkPacket);
						if (!isMessageHandled)
						{
							show_debug_message(string("Unable to handle message type: {0}", messageType));
						}
					}
				}
			}
		}
		return isMessageHandled;
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
}