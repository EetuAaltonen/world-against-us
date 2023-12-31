function NetworkHandler() constructor
{
	socket = undefined;
	
	client_id = UNDEFINED_UUID;
	network_status = NETWORK_STATUS.OFFLINE;
	host_address = undefined;
	host_port = undefined;
	
	pre_alloc_network_buffer = undefined;
	delete_socket_timer = new Timer(TimerFromMilliseconds(1000));
	packet_send_interval_threshold = 30; // == 30ms
	last_packet_time = current_time;
	
	network_packet_builder = new NetworkPacketBuilder();
	network_packet_parser = new NetworkPacketParser();
	network_packet_handler = new NetworkPacketHandler();
	network_packet_tracker = new NetworkPacketTracker();
	network_packet_queue = ds_priority_create();
	
	network_connection_sampler = new NetworkConnectionSampler();
	network_error_handler = new NetworkErrorHandler();
	
	network_region_handler = new NetworkRegionHandler();
	
	static OnDestroy = function()
	{
		network_region_handler.OnDestroy();
		network_region_handler = undefined;
	}
	
	static Update = function()
	{
		if (delete_socket_timer.IsTimerStopped())
		{
			if (!DeleteSocket())
			{
				show_debug_message("Failed to delete socket on delete socket timer stopped");
			}
		} else {
			delete_socket_timer.Update();
			if (network_status == NETWORK_STATUS.CONNECTING || global.MultiplayerMode)
			{
				if (global.MultiplayerMode)
				{
					// UPDATE NETWORK CONNECTION SAMPLING
					network_connection_sampler.Update();
					
					// UPDATE REGION HANDLER
					network_region_handler.Update();
				}
				
				// UPDATE NETWORK PACKET TRACKER
				network_packet_tracker.Update();
				
				var packetSendInterval = current_time - last_packet_time;
				if (packetSendInterval >= packet_send_interval_threshold)
				{
					if (!ds_priority_empty(network_packet_queue))
					{
						var networkPacket = ds_priority_find_min(network_packet_queue);
						if (!is_undefined(networkPacket))
						{
							if (network_packet_tracker.PatchNetworkPacketAckRange(networkPacket))
							{
								if (network_packet_tracker.PatchNetworkPacketSequenceNumber(networkPacket))
								{
									if (network_packet_builder.CreatePacket(pre_alloc_network_buffer, networkPacket))
									{
										var networkPacketSize = SendPacketOverUDP();
										if (networkPacketSize > 0)
										{
											ds_priority_delete_min(network_packet_queue);
											// TODO: Disable for debugging
											//show_debug_message(string("Network packet ({0}) {1}kb sent", networkPacket.header.message_type, networkPacketSize * 0.001));
											//if (networkPacket.header.message_type == MESSAGE_TYPE.PATROLS_DATA_PROGRESS_POSITION)
											//{
												global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.INFO, string("Network packet ({0}) {1}kb sent >> Packet send interval {2}ms", networkPacket.header.message_type, networkPacketSize * 0.001, packetSendInterval));
												last_packet_time = current_time;
												//global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.INFO, string("DeltaTime {0}ms", delta_time * 0.001));
											//}
										} else {
											show_debug_message(string("Failed to send packet with message type {0}", networkPacket.header.message_type));	
										}
										// UPDATE DATA SENT RATE
										global.NetworkConnectionSamplerRef.data_sent_rate += networkPacketSize;
									}
								}
							} else {
								// DELETE UNNECESSARY ACKNOWLEDGMENTS
								if (networkPacket.header.message_type == MESSAGE_TYPE.ACKNOWLEDGMENT)
								{
									ds_priority_delete_min(network_packet_queue);
								}
							}
						}
					}
				}
			}
			/*
			// TODO: Move this logic elsewhere
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
									[
										CreateWindowGameOver(GAME_WINDOW.GameOver, -1)
									],
									GUI_CHAIN_RULE.OverwriteAll,
									undefined, undefined
								);
								global.GUIStateHandlerRef.RequestGUIState(guiState);
							}
						}
					}
				}
			}*/
		}
	}
	
	static SendPacketOverUDP = function()
	{
		var networkPacketSize = 0;
		if (!is_undefined(socket))
		{
			networkPacketSize = network_send_udp_raw(socket, host_address, host_port, pre_alloc_network_buffer, buffer_tell(pre_alloc_network_buffer));
		}
		return networkPacketSize;
	}
	
	static CreateSocket = function()
	{
		var isSocketCreated = false;
		if (network_status == NETWORK_STATUS.OFFLINE && is_undefined(socket))
		{
			socket = network_create_socket(network_socket_udp);
			pre_alloc_network_buffer = buffer_create(256, buffer_grow, 1);
			isSocketCreated = true;
		} else {
			// TODO: Generic error handler
			show_message("Client is already connected or socket already exists!");
		}
		return isSocketCreated;
	}
	
	static DeleteSocket = function()
	{
		var isSocketDeleted = false;
		if (!is_undefined(socket))
		{
			network_destroy(socket);
			socket = undefined;
			
			buffer_delete(pre_alloc_network_buffer);
		
			// RESET NETWORK PROPERTIES
			client_id = UNDEFINED_UUID;
			network_status = NETWORK_STATUS.OFFLINE;
			host_address = undefined;
			host_port = undefined;
			ClearDSPriorityAndDeleteValues(network_packet_queue);
			delete_socket_timer.StopTimer();
		
			// RESET CONNECTION SAMPLING
			network_connection_sampler.ResetNetworkConnectionSampling();
		
			// CLEAR IN FLIGHT NETWORK PACKET TRACKING
			network_packet_tracker.ResetNetworkPacketTracking();
			
			// CLEAR REGION DATA
			network_region_handler.ResetRegionData();
		
			global.MultiplayerMode = false;
			
			// REQUEST GUI STATE RESET
			global.GUIStateHandlerRef.RequestGUIStateReset();

			// RETURN TO MAIN MENU
			if (room != roomMainMenu)
			{
				global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
			}
			isSocketDeleted = true;
		}
		return isSocketDeleted;
	}
	
	static RequestConnectSocket = function(_address, _port)
	{
		var isConnecting = false;
		if (!is_undefined(socket)) {
			host_address = _address;
			host_port = _port;
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONNECT_TO_HOST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader, undefined,
				PACKET_PRIORITY.HIGH,
				AckTimeoutFuncResend
			);
			if (AddPacketToQueue(networkPacket))
			{
				network_status = NETWORK_STATUS.CONNECTING;
				isConnecting = true;
			} else {
				show_debug_message("Failed to connect socket");
			}
		}
		return isConnecting;
	}
	
	static RequestDisconnectSocket = function()
	{
		// FORCE DISCONNECT MESSAGE IF ONLINE
		if (global.MultiplayerMode)
		{
			OnDisconnect();
			
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.DISCONNECT_FROM_HOST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined,
				PACKET_PRIORITY.CRITICAL,
				undefined
			);
			if (AddPacketToQueue(networkPacket))
			{
				network_status = NETWORK_STATUS.DISCONNECTING;
			} else {
				show_debug_message("Failed to queue disconnect");
				if (!DeleteSocket())
				{
					show_debug_message("Failed to delete socket on failed disconnect queue");
				}
			}
		} else {
			if (!DeleteSocket())
			{
				show_debug_message("Failed to delete socket on request disconnect socket");
			}
		}
	}
	
	static DisconnectTimeout = function()
	{
		show_message("Failed to reach the server. Disconnecting...");
		RequestDisconnectSocket();
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
	
	static ResendNetworkPacket = function(_networkPacket)
	{
		var isPacketResend = false;
		if (network_packet_tracker.RemoveTrackedInFlightPacket(_networkPacket.header.sequence_number))
		{
			_networkPacket.priority = PACKET_PRIORITY.CRITICAL;
			if (AddPacketToQueue(_networkPacket))
			{
				show_debug_message(string("Resending packet with message type {0}", _networkPacket.header.message_type));
				isPacketResend = true;
			}
		}
		return isPacketResend;
	}
	
	static OnConnection = function()
	{
		network_status = NETWORK_STATUS.CONNECTED;
		global.MultiplayerMode = true;
		
		// START PINGING
		network_connection_sampler.StartPinging();
		// SENT RATE SAMPLING
		network_connection_sampler.sent_rate_sample_timer.StartTimer();
	}
	
	static OnDisconnect = function()
	{
		// STOP PINGING
		network_connection_sampler.StopPinging(-1);
		// STOP SENT RATE SAMPLING
		network_connection_sampler.sent_rate_sample_timer.StopTimer();
		
		// RESET REGION DATA
		network_region_handler.ResetRegionData();
			
		// DELETE SOCKET WITH DELAY
		delete_socket_timer.StartTimer();
	}
	
	static OnRoomStart = function()
	{
		// VALIDATE CONTAINERS
		if (!network_region_handler.network_region_object_handler.ValidateRegionContainers())
		{
			show_message("Error occured during OnRoomStart");
			RequestDisconnectSocket();
		}
		
		// REQUEST REGION SYNC
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_INSTANCE);
		var networkPacket = new NetworkPacket(
			networkPacketHeader, undefined,
			PACKET_PRIORITY.DEFAULT,
			AckTimeoutFuncResend
		);
		if (!AddPacketToQueue(networkPacket))
		{
			show_debug_message("Failed to add 'sync instance' packet to queue");
		}
	}
	
	static OnRoomEnd = function()
	{
		network_region_handler.OnRoomEnd();
	}
	
	static RequestJoinGame = function()
	{
		var isJoining = false;
		if (!is_undefined(socket)) {
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_JOIN_GAME);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined, PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (AddPacketToQueue(networkPacket))
			{
				network_status = NETWORK_STATUS.JOINING_TO_GAME;
				isJoining = true;
			}
		}
		return isJoining;
	}
	
	static HandleMessage = function(_msg)
	{
		var isMessageHandled = false;
		if (!is_undefined(_msg))
		{
			var networkPacket = network_packet_parser.ParsePacket(_msg);
			if (!is_undefined(networkPacket))
			{
				var messageType = networkPacket.header.message_type;
				var sequenceNumber = networkPacket.header.sequence_number;
				var ackCount = networkPacket.header.ack_count;
				var ackRange = networkPacket.header.ack_range;

				switch (messageType)
				{
					case MESSAGE_TYPE.INVALID_REQUEST:
					{
						if (!is_undefined(networkPacket.payload))
						{
							isMessageHandled = network_error_handler.HandleInvalidRequest(networkPacket);
						}
					} break;
					case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
					{
						global.NetworkHandlerRef.network_status = NETWORK_STATUS.DISCONNECTED;
						if (DeleteSocket())
						{
							isMessageHandled = true;
						} else {
							show_debug_message("Failed to delete socket on MESSAGE_TYPE.DISCONNECT_FROM_HOST");
						}
					} break;
					case MESSAGE_TYPE.SERVER_ERROR:
					{
						if (!is_undefined(networkPacket.payload))
						{
							isMessageHandled = network_error_handler.HandleServerError(networkPacket);
						}
					} break;
					default:
					{
						if (network_packet_tracker.ProcessAckRange(ackCount, ackRange))
						{
							if (network_packet_tracker.ProcessSequenceNumber(sequenceNumber, messageType))
							{
								switch (messageType)
								{
									case MESSAGE_TYPE.ACKNOWLEDGMENT:
									{
										// NO FURTHER ACTIONS
										isMessageHandled = true;
									} break;
									case MESSAGE_TYPE.CONNECT_TO_HOST:
									{
										if (network_status == NETWORK_STATUS.CONNECTING)
										{
											// SET NETWORK PROPERTIES
											client_id = networkPacket.header.client_id;
											OnConnection();
						
											// CLOSE CONNECT WINDOW
											if (global.GUIStateHandlerRef.CloseCurrentGUIState())
											{
												// OPEN SAVE SELECTION
												var mainMenuMultiplayerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuMultiplayer);
												if (!is_undefined(mainMenuMultiplayerWindow))
												{
													global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.SaveSelection, [
														CreateWindowMainMenuSaveSelection(GAME_WINDOW.MainMenuSaveSelection, mainMenuMultiplayerWindow.zIndex - 1, OnClickMenuMultiplayerPlay)
													], GUI_CHAIN_RULE.Overwrite);
												}
											}
								
											// RESPOND WITH ACKNOWLEDGMENT TO END CONNECTING TO HOST
											isMessageHandled = QueueAcknowledgmentResponse();
										}
									} break;
									case MESSAGE_TYPE.REQUEST_JOIN_GAME:
									{
										if (network_status == NETWORK_STATUS.JOINING_TO_GAME)
										{
											if (network_packet_handler.HandlePacket(networkPacket))
											{
												var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_WORLD_STATE);
												var networkPacket = new NetworkPacket(
													networkPacketHeader,
													undefined,
													PACKET_PRIORITY.DEFAULT,
													AckTimeoutFuncResend
												);
												if (AddPacketToQueue(networkPacket))
												{
													network_status = NETWORK_STATUS.SYNC_WORLD_STATE;
													// ACKNOWLEDGMENT RESPONSE ON NEXT STEP
													isMessageHandled = true;
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
												var networkPacket = new NetworkPacket(
													networkPacketHeader,
													undefined,
													PACKET_PRIORITY.DEFAULT,
													AckTimeoutFuncResend
												);
												if (AddPacketToQueue(networkPacket))
												{
													network_status = NETWORK_STATUS.SYNC_DATA;
													// ACKNOWLEDGMENT RESPONSE ON NEXT STEP
													isMessageHandled = true;
												}
											}
										}
									} break;
									case MESSAGE_TYPE.DATA_PLAYER_SYNC:
									{
										if (network_status == NETWORK_STATUS.SYNC_DATA)
										{
											// RESPOND WITH ACKNOWLEDGMENT TO END JOIN GAME HANDSHAKE
											if (QueueAcknowledgmentResponse())
											{
												network_status = NETWORK_STATUS.SESSION_IN_PROGRESS;
												// ACKNOWLEDGMENT RESPONSE ON NEXT STEP
												isMessageHandled = global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_CAMP);
											}
										}
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
					}
				}
			}
		} else {
			// TODO: Generic error handling
			show_debug_message("Unable to handle undefined message");
		}
		return isMessageHandled;
	}
	
	static QueueAcknowledgmentResponse = function()
	{
		var isResponseQueued = false;
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.ACKNOWLEDGMENT);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			undefined,
			PACKET_PRIORITY.DEFAULT
		);
		isResponseQueued = AddPacketToQueue(networkPacket);
		return isResponseQueued;
	}
	
	static CancelPacketsSendQueueAndTrackingByMessageType = function(_messageType)
	{
		// CLEAR IN-FLIGHT PACKETS
		network_packet_tracker.ClearInFlightPacketsByMessageType(_messageType);
		
		// REMOVE FROM PACKET QUEUE
		var tempNetworkPacketQueue = ds_priority_create();
		ds_priority_copy(tempNetworkPacketQueue, network_packet_queue);
		while (!ds_priority_empty(tempNetworkPacketQueue) && !ds_priority_empty(network_packet_queue))
		{
			var networkPacket = ds_priority_find_min(tempNetworkPacketQueue);
			if (networkPacket.header.message_type == _messageType)
			{
				// TODO: For Debugging
				show_message(string("1. network_packet_queue: {0}", ds_priority_size(network_packet_queue)));
				ds_priority_delete_value(network_packet_queue, networkPacket);
				show_message(string("2. network_packet_queue: {0}", ds_priority_size(network_packet_queue)));
			}
			ds_priority_delete_min(tempNetworkPacketQueue);
		}
	}
}