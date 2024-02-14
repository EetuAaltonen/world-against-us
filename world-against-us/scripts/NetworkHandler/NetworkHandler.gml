function NetworkHandler() constructor
{
	socket = undefined;
	
	client_id = UNDEFINED_UUID;
	player_tag = EMPTY_STRING;
	network_status = NETWORK_STATUS.OFFLINE;
	host_address = undefined;
	host_port = undefined;
	
	// NETWORK BUFFERS
	pre_alloc_network_buffer = undefined;
	pre_alloc_network_buffer_compressed = undefined;
	
	
	delete_socket_timer = new Timer(TimerFromMilliseconds(1000));
	packet_send_rate = 1000 / 33.33333; // == 30ms == ~Every other frame
	last_packet_time = current_time;
	
	network_packet_builder = new NetworkPacketBuilder();
	network_packet_parser = new NetworkPacketParser();
	network_packet_handler = new NetworkPacketHandler();
	network_packet_tracker = new NetworkPacketTracker();
	network_packet_queue = ds_queue_create();
	
	network_packet_delivery_policy_handler = new NetworkPacketDeliveryPolicyHandler();
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
				if (packetSendInterval >= packet_send_rate)
				{
					if (!ds_queue_empty(network_packet_queue))
					{
						var networkPacket = ds_queue_dequeue(network_packet_queue);
						if (!is_undefined(networkPacket))
						{
							var sentNetworkPacketBytes = PrepareAndSendNetworkPacket(networkPacket);
							if (sentNetworkPacketBytes > 0)
							{
								var consoleLog = string(
									"Network packet ({0}) {1}kb sent >> Packet send interval {2}ms",
									networkPacket.header.message_type,
									BytesToKilobits(sentNetworkPacketBytes),
									packetSendInterval
								);
								global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.INFO, consoleLog);
								last_packet_time = current_time;
							} else {
								// IGNORE DROPPED UNECESSARY ACKNOWLEDGMENTS
								if (networkPacket.header.message_type != MESSAGE_TYPE.ACKNOWLEDGMENT)
								{
									var consoleLog = string("Failed to send packet with message type {0}", networkPacket.header.message_type);
									global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
								}
							}
							// UPDATE DATA OUT RATE
							global.NetworkConnectionSamplerRef.data_out_rate += sentNetworkPacketBytes;
						}
					}
				}
			}
		}
	}
	
	static PrepareAndSendNetworkPacket = function(_networkPacket)
	{
		var sentNetworkPacketBytes = 0;
		if (network_packet_tracker.PatchNetworkPacketAckRange(_networkPacket))
		{
			if (network_packet_tracker.PatchNetworkPacketSequenceNumber(_networkPacket))
			{
				if (network_packet_builder.CreatePacket(pre_alloc_network_buffer, _networkPacket))
				{
					sentNetworkPacketBytes = SendPacketOverUDP();
				}
			}
		}
		return sentNetworkPacketBytes;
	}
	
	static SendPacketOverUDP = function()
	{
		var networkPacketSize = 0;
		if (!is_undefined(socket))
		{
			// COMPRESS NETWORK BUFFER
			var compressNetworkBuffer = buffer_compress(pre_alloc_network_buffer, 0, buffer_tell(pre_alloc_network_buffer));
			networkPacketSize = network_send_udp_raw(socket, host_address, host_port, compressNetworkBuffer, buffer_get_size(compressNetworkBuffer));
			// DELETE COMPRESS NETWORK BUFFER
			buffer_delete(compressNetworkBuffer);
		}
		return networkPacketSize;
	}
	
	/// @function		CreateSocket()
	/// @description	Creates UDP socket and allocates new network buffer
	/// @return {bool}
	static CreateSocket = function()
	{
		var isSocketCreated = false;
		if (network_status == NETWORK_STATUS.OFFLINE && is_undefined(socket))
		{
			socket = network_create_socket(network_socket_udp);
			pre_alloc_network_buffer = buffer_create(256, buffer_grow, 1);
			pre_alloc_network_buffer_compressed = buffer_create(256, buffer_grow, 1);
			isSocketCreated = true;
		} else {
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Client already connected or socket already exists");
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
			buffer_delete(pre_alloc_network_buffer_compressed);
		
			// RESET NETWORK PROPERTIES
			client_id = UNDEFINED_UUID;
			player_tag = EMPTY_STRING;
			network_status = NETWORK_STATUS.OFFLINE;
			host_address = undefined;
			host_port = undefined;
			
			ClearDSQueueAndDeleteValues(network_packet_queue);
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
	
	static RequestConnectSocket = function(_playerTag, _address, _port)
	{
		var isConnecting = false;
		if (!is_undefined(socket)) {
			player_tag = _playerTag;
			host_address = _address;
			host_port = _port;
			
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONNECT_TO_HOST);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				player_tag,
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
	
	static RequestDisconnectSocket = function(_isRequestImmediate)
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
			if (_isRequestImmediate)
			{
				// PREPARE AND SEND PACKET
				var sentNetworkPacketBytes = PrepareAndSendNetworkPacket(networkPacket);
				if (sentNetworkPacketBytes > 0)
				{
					network_status = NETWORK_STATUS.OFFLINE;
				} else {
					show_debug_message("Failed to send immediate disconnect");
				}
				// DELETE SOCKET
				if (!DeleteSocket())
				{
					show_debug_message("Failed to delete socket on immediate disconnect");
				}
			} else {
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
		// CONSOLE LOG
		global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Connection timed out. Disconnecting...");
		
		// NOTIFICATION LOG
		global.NotificationHandlerRef.AddNotification(
			new Notification(
				undefined, "Connection timed out. Disconnecting...",
				undefined, NOTIFICATION_TYPE.Log
			)
		);
		RequestDisconnectSocket(true);
	}
	
	static AddPacketToQueue = function(_networkPacket)
	{
		var isAddedToQueue = false;
		if (!is_undefined(_networkPacket))
		{
			// TODO: Compare priorities
			ds_queue_enqueue(network_packet_queue, _networkPacket);
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
		network_connection_sampler.data_rate_sample_timer.StartTimer();
	}
	
	static OnDisconnect = function()
	{
		// SAVE GAME
		global.GameSaveHandlerRef.SaveGame();
		
		// RESET CONNECTION SAMPLING
		network_connection_sampler.ResetNetworkConnectionSampling();
		
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
			RequestDisconnectSocket(true);
		} else {
			// REQUEST REGION SYNC
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.SYNC_INSTANCE);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				undefined,
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
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
			// UPDATE DATA IN RATE
			global.NetworkConnectionSamplerRef.data_in_rate += buffer_get_size(_msg);
			
			var networkPacket = network_packet_parser.ParsePacket(_msg);
			if (!is_undefined(networkPacket))
			{
				var messageType = networkPacket.header.message_type;
				if (messageType == MESSAGE_TYPE.PING)
				{
					var receivedPingSample = networkPacket.payload;
					global.NetworkConnectionSamplerRef.ProcessPingSample(receivedPingSample);
				} else {
					var sequenceNumber = networkPacket.header.sequence_number;
					var ackCount = networkPacket.header.ack_count;
					var ackRange = networkPacket.header.ack_range;

					switch (messageType)
					{
						case MESSAGE_TYPE.INVALID_REQUEST:
						{
							var invalidRequestInfo = networkPacket.payload;
							if (!is_undefined(invalidRequestInfo))
							{
								isMessageHandled = network_error_handler.HandleInvalidRequest(invalidRequestInfo);
							}
						} break;
						case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
						{
							// SET NETWORK STATUS
							global.NetworkHandlerRef.network_status = NETWORK_STATUS.DISCONNECTED;
						
							// SHOW POP-UP NOTIFICATION
							global.NotificationHandlerRef.AddNotificationPlayerDisconnected(player_tag);
						
							// DELETE SOCKET
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
									// MESSAGES WITHOUT NETWORK STATUS THRESHOLD
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
												
												// SHOW POP-UP NOTIFICATION
												global.NotificationHandlerRef.AddNotificationPlayerConnected(player_tag);
											
												// OPEN SAVE SELECTION
												var mainMenuMultiplayerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.MainMenuMultiplayer);
												if (!is_undefined(mainMenuMultiplayerWindow))
												{
													global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.SaveSelection, [
														CreateWindowMainMenuSaveSelection(GAME_WINDOW.MainMenuSaveSelection, mainMenuMultiplayerWindow.zIndex - 1, OnClickMenuSaveSelectionPlay)
													], GUI_CHAIN_RULE.OverwriteAll);
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
													// TODO: DATA_PLAYER_SYNC is empty and does not do anything
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
										case MESSAGE_TYPE.REMOTE_CONNECTED_TO_HOST:
										{
											var remotePlayerInfo = networkPacket.payload;
											if (!is_undefined(remotePlayerInfo))
											{
												global.NotificationHandlerRef.AddNotificationPlayerConnected(remotePlayerInfo.player_tag);
												// RESPOND WITH ACKNOWLEDGMENT TO REMOTE CONNECTED TO HOST
												isMessageHandled = QueueAcknowledgmentResponse();
											}
										} break;
										case MESSAGE_TYPE.REMOTE_DISCONNECT_FROM_HOST:
										{
											var remotePlayerInfo = networkPacket.payload;
											if (!is_undefined(remotePlayerInfo))
											{
												if (IS_ROOM_IN_GAME_WORLD)
												{
													global.NetworkRegionObjectHandlerRef.DestroyRemotePlayerInstanceObjectById(remotePlayerInfo.client_id);	
												}
												
												global.NotificationHandlerRef.AddNotificationPlayerDisconnected(remotePlayerInfo.player_tag);
												// RESPOND WITH ACKNOWLEDGMENT TO REMOTE DISCONNECTED FROM HOST
												isMessageHandled = QueueAcknowledgmentResponse();
											}
										} break;
										default:
										{
											isMessageHandled = network_packet_handler.HandlePacket(networkPacket);
										}
									}
								}
							}
							if (!isMessageHandled)
							{
								var consoleLog = string("Unable to handle message type {0} while network status {1}", messageType, network_status);
								global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
								// TODO: Implement better logic for unhandled network packets
								//RequestDisconnectSocket(false);
							}
						}
					}
				}
			}
		} else {
			// TODO: Generic error handling
			var consoleLog = string("Unable to handle undefined message", messageType);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
			RequestDisconnectSocket(false);
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
		
		var queueSize = ds_queue_size(network_packet_queue);
		repeat(queueSize)
		{
			var networkPacket = ds_queue_dequeue(network_packet_queue);
			if (networkPacket.header.message_type == _messageType)
			{
				// REMOVE FROM PACKET QUEUE WITHOUT RESTORE
				var consoleLog = string(
					"Network packet with message type {0} cancelled out from queue and tracking",
					networkPacket.header.message_type
				);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
			} else {
				// RESTORE NETWORK PACKET BACK TO QUEUE
				// WHICH WILL EVENTUALLY SHIFT ALL KEPT PACKETS BACK TO THEIR ORIGINAL POSITION ON QUEUE
				ds_queue_enqueue(network_packet_queue, networkPacket);
			}
		}
	}
}