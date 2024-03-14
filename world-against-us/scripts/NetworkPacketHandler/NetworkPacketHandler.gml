function NetworkPacketHandler() constructor
{
	static HandlePacket = function(_networkPacket)
	{
		var isPacketHandled = false;
		if (!is_undefined(_networkPacket))
		{
			try
			{
				var messageType = _networkPacket.header.message_type;
				var payload = _networkPacket.payload;
				switch (messageType)
				{
					case MESSAGE_TYPE.REQUEST_JOIN_GAME:
					{
						var networkJoinGameRequest = payload;
						if (!is_undefined(networkJoinGameRequest))
						{
							global.NetworkRegionHandlerRef.region_id = networkJoinGameRequest.region_id;
							global.NetworkRegionHandlerRef.room_index = networkJoinGameRequest.room_index;
							global.NetworkRegionHandlerRef.owner_client = networkJoinGameRequest.owner_client;
							
							// ACKNOWLEDGMENT RESPONSE ON NEXT STEP
							isPacketHandled = true;
						}
					} break;
					case MESSAGE_TYPE.SYNC_WORLD_STATE:
					{
						var networkWorldStateSync = payload;
						if (!is_undefined(networkWorldStateSync))
						{
							global.WorldStateHandlerRef.date_time.year = networkWorldStateSync.date_time.year;
							global.WorldStateHandlerRef.date_time.month = networkWorldStateSync.date_time.month;
							global.WorldStateHandlerRef.date_time.day = networkWorldStateSync.date_time.day;
							global.WorldStateHandlerRef.date_time.hours = networkWorldStateSync.date_time.hours;
							global.WorldStateHandlerRef.date_time.minutes = networkWorldStateSync.date_time.minutes;
							global.WorldStateHandlerRef.date_time.seconds = networkWorldStateSync.date_time.seconds;
							global.WorldStateHandlerRef.date_time.milliseconds = networkWorldStateSync.date_time.milliseconds;
									
							global.WorldStateHandlerRef.SetWeather(networkWorldStateSync.weather);
							// ACKNOWLEDGMENT RESPONSE ON NEXT STEP
							isPacketHandled = true;
						}
					} break;
					case MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER:
					{
						var networkWorldStateWeather = payload;
						if (!is_undefined(networkWorldStateWeather))
						{
							if (global.WorldStateHandlerRef.SetWeather(networkWorldStateWeather))
							{
								// RESPOND WITH ACKNOWLEDGMENT TO END WEATHER STATE SYNC
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.SYNC_INSTANCE:
					{
						var regionSync = payload;
						if (!is_undefined(regionSync))
						{
							var region = regionSync.region;
							if (!is_undefined(region))
							{
								global.NetworkRegionHandlerRef.owner_client = region.owner_client;
								global.NetworkRegionRemotePlayerHandlerRef.SyncRegionRemotePlayers(region.local_players);
								global.NetworkRegionObjectHandlerRef.SyncRegionPatrols(region.arrived_patrols);
							}
							var scoutingDroneInstanceObject = regionSync.scouting_drone;
							if (!is_undefined(scoutingDroneInstanceObject))
							{
								global.NetworkRegionObjectHandlerRef.SpawnScoutingDrone(scoutingDroneInstanceObject);
							}
							// RESPOND WITH ACKNOWLEDGMENT TO END SYNC INSTANCE
							isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
						}
					} break;
					case MESSAGE_TYPE.SYNC_INSTANCE_OWNER:
					{
						var regionOwnerClient = payload;
						if (!is_undefined(regionOwnerClient))
						{
							global.NetworkRegionHandlerRef.owner_client = regionOwnerClient;
							// RESPOND WITH ACKNOWLEDGMENT TO SYNC INSTANCE OWNER
							isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
						}
					} break;
					case MESSAGE_TYPE.REMOTE_ENTERED_THE_INSTANCE:
					{
						var remotePlayerInfo = payload;
						if (!is_undefined(remotePlayerInfo))
						{
							if (global.NetworkRegionRemotePlayerHandlerRef.SyncRegionRemotePlayerEnter(remotePlayerInfo))
							{
								global.NotificationHandlerRef.AddNotification(
									new Notification(
										sprIconRemoteEnterRegion, "Client entered the region",
										string("{0} entered the area", remotePlayerInfo.player_tag),
										NOTIFICATION_TYPE.Popup
									)
								);
							}
							
							// RESPOND WITH ACKNOWLEDGMENT TO REMOTE ENTERED THE INSTANCE
							isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
						}
					} break;
					case MESSAGE_TYPE.REMOTE_DATA_POSITION:
					{
						var remoteInstanceObject = payload;
						if (!is_undefined(remoteInstanceObject))
						{
							// TODO: Polish client side interpolation / input simulation
							global.NetworkRegionRemotePlayerHandlerRef.UpdateRegionRemotePosition(remoteInstanceObject);
							isPacketHandled = true;
						}
					} break;
					case MESSAGE_TYPE.REMOTE_DATA_MOVEMENT_INPUT:
					{
						var remoteDataMovementInput = payload;
						if (!is_undefined(remoteDataMovementInput))
						{
							// TODO: Polish client side interpolation / input simulation
							global.NetworkRegionRemotePlayerHandlerRef.UpdateRegionRemoteInput(remoteDataMovementInput);
							isPacketHandled = true;
						}
					} break;
					case MESSAGE_TYPE.REMOTE_LEFT_THE_INSTANCE:
					{
						var remotePlayerInfo = payload;
						if (!is_undefined(remotePlayerInfo))
						{
							if (global.NetworkRegionRemotePlayerHandlerRef.SyncRegionRemotePlayerLeave(remotePlayerInfo))
							{
								global.NotificationHandlerRef.AddNotification(
									new Notification(
										sprIconRemoteLeaveRegion, "Client left the region",
										string("{0} left the area", remotePlayerInfo.player_tag),
										NOTIFICATION_TYPE.Popup
									)
								);
								
								// RESPOND WITH ACKNOWLEDGMENT TO REMOTE LEFT THE INSTANCE
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.REMOTE_RETURNED_TO_CAMP:
					{
						var remotePlayerInfo = payload;
						if (!is_undefined(remotePlayerInfo))
						{
							if (global.NetworkRegionRemotePlayerHandlerRef.SyncRegionRemotePlayerReturnCamp(remotePlayerInfo))
							{
								global.NotificationHandlerRef.AddNotificationPlayerReturnedToCamp(remotePlayerInfo.player_tag);
								
								// RESPOND WITH ACKNOWLEDGMENT TO REMOTE RETURNED TO CAMP
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.REQUEST_PLAYER_LIST:
					{
						var playerList = payload;
						var playerListWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.PlayerList);
						if (!is_undefined(playerListWindow))
						{
							var playerListElement = playerListWindow.GetChildElementById("PlayerList");
							if (!is_undefined(playerListElement))
							{
								playerListElement.UpdateDataCollection(playerList);
										
								// HIDE LOADING ICON
								var playerListLoadingElement = playerListWindow.GetChildElementById("PlayerListLoading");
								if (!is_undefined(playerListLoadingElement))
								{
									playerListLoadingElement.isVisible = false;
								}
								// RESPOND WITH ACKNOWLEDGMENT TO END PLAYER LIST REQUEST
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
					{
						var availableInstances = payload;
						var worldMapWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.WorldMap);
						if (!is_undefined(worldMapWindow))
						{
							var instanceListElement = worldMapWindow.GetChildElementById("InstanceList");
							if (!is_undefined(instanceListElement))
							{
								instanceListElement.UpdateDataCollection(availableInstances);
										
								// HIDE LOADING ICON
								var instanceListLoadingElement = worldMapWindow.GetChildElementById("InstanceListLoading");
								if (!is_undefined(instanceListLoadingElement))
								{
									instanceListLoadingElement.isVisible = false;
								}
								// RESPOND WITH ACKNOWLEDGMENT TO END INSTANCE LIST REQUEST
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							} else {
								global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Unable to fetch instance list window element on request instance list handling");
							}
						} else {
							global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Unable to fetch world map window on request instance list handling");
						}
					} break;
					case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
					{
						var worldMapFastTravelInfo = payload;
						if (!is_undefined(worldMapFastTravelInfo))
						{
							var destinationRegionId = worldMapFastTravelInfo.destination_region_id;
							if (!is_undefined(destinationRegionId))
							{
								var destinationRoomIndex = worldMapFastTravelInfo.destination_room_index;
								if (!is_undefined(destinationRoomIndex))
								{
									var sourceRegionId = worldMapFastTravelInfo.source_region_id;
									if (!is_undefined(sourceRegionId))
									{
										if (global.RoomChangeHandlerRef.RequestRoomChange(destinationRoomIndex))
										{
											// CACHE FAST TRAVEL INFO
											global.RoomChangeHandlerRef.RequestCacheFastTravelInfo(worldMapFastTravelInfo);
											
											// SET REGION DETAILS
											global.NetworkRegionHandlerRef.region_id = destinationRegionId;
											global.NetworkRegionHandlerRef.prev_region_id = sourceRegionId;
											global.NetworkRegionHandlerRef.room_index = destinationRoomIndex;
											global.NetworkRegionHandlerRef.owner_client = undefined;
											
											// POP-UP NOTIFICATION
											if (destinationRoomIndex == ROOM_INDEX_CAMP)
											{
												global.NotificationHandlerRef.AddNotificationPlayerReturnedToCamp(global.NetworkHandlerRef.player_tag);
											}
											
											// DEBUG MONITOR
											global.DebugMonitorMultiplayerHandlerRef.EndFastTravelTimeSampling();
												
											// RESPOND WITH ACKNOWLEDGMENT TO SUCCESS FAST TRAVEL REQUEST
											isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
										}
									}
								}
							}
						}
					} break;
					case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
					{
						var containerContentInfo = payload;
						if (!is_undefined(containerContentInfo))
						{
							var targetContainer = undefined;
							var containerCount = instance_number(objContainerParent);
							for (var i = 0; i < containerCount; i++)
							{
								var container = instance_find(objContainerParent, i);
								if (!is_undefined(container))
								{
									if (container.containerId == containerContentInfo.container_id)
									{
										targetContainer = container;
										break;
									}
								}
							}
							if (instance_exists(targetContainer))
							{
								if (!is_undefined(targetContainer.inventory))
								{
									var activeInventoryStream = new NetworkInventoryStream(
										targetContainer.containerId,
										targetContainer.inventory,
										4, true, 0
									);
									// CHECK IF SERVER HAS CONTAINER CONTENT
									if (containerContentInfo.content_count == -1)
									{
										if (targetContainer.inventory.type == INVENTORY_TYPE.LootContainer)
										{
											if (!is_undefined(targetContainer.lootTableTag))
											{
												// GENERATE LOOT
												RollContainerLoot(targetContainer.lootTableTag, targetContainer.inventory);
												activeInventoryStream.stream_end_index = targetContainer.inventory.GetItemCount();
											}
										}
									} else {
										activeInventoryStream.is_stream_sending = false;
									}
									
									// SET REQUESTED CONTAINER ACCESS
									global.NetworkRegionObjectHandlerRef.requested_container_access = containerContentInfo.container_id;
									
									// SET ACTIVE INVENTORY STREAM
									global.NetworkRegionObjectHandlerRef.active_inventory_stream = activeInventoryStream;
											
									// REQUEST CONTAINER INVENTORY DATA STREAM
									var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM);
									var networkPacket = new NetworkPacket(
										networkPacketHeader,
										activeInventoryStream,
										PACKET_PRIORITY.DEFAULT,
										AckTimeoutFuncResend
									);
									isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
								}
							}
						}
					} break;
					case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
					{
						var activeInventoryStream = global.NetworkRegionObjectHandlerRef.active_inventory_stream;
						if (!is_undefined(activeInventoryStream))
						{
							if (activeInventoryStream.is_stream_sending)
							{
								isPacketHandled = activeInventoryStream.SendNextInventoryStreamItems();
							} else {
								isPacketHandled = activeInventoryStream.RequestNextInventoryStreamItems();
							}
						}
					}break;
					case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
					{
						var inventoryStreamItems = payload;
						if (!is_undefined(inventoryStreamItems))
						{
							var activeInventoryStream = global.NetworkRegionObjectHandlerRef.active_inventory_stream;
							if (!is_undefined(activeInventoryStream))
							{
								var regionId = global.NetworkRegionHandlerRef.region_id;
								if (inventoryStreamItems.region_id == regionId)
								{
									if (activeInventoryStream.inventory_id == inventoryStreamItems.inventory_id)
									{
										if (activeInventoryStream.is_stream_sending)
										{
											// NO NEED FOR SEPARATE ACKNOWLEDGMENT WHILE STREAMING
											isPacketHandled = activeInventoryStream.SendNextInventoryStreamItems();
										} else {
											var networkInventoryStreamItems = payload;
											if (!is_undefined(networkInventoryStreamItems))
											{
												var items = networkInventoryStreamItems.items;
												if (activeInventoryStream.target_inventory.AddMultipleItems(items))
												{
													// NO NEED FOR SEPARATE ACKNOWLEDGMENT WHILE STREAMING
													isPacketHandled = activeInventoryStream.RequestNextInventoryStreamItems();
												}
											}
										}
									}
								}
							}
						}
					} break;
					case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
					{
						var inventoryStreamItems = payload;
						if (!is_undefined(inventoryStreamItems))
						{
							var activeInventoryStream = global.NetworkRegionObjectHandlerRef.active_inventory_stream;
							if (!is_undefined(activeInventoryStream))
							{
								var regionId = global.NetworkRegionHandlerRef.region_id;
								if (inventoryStreamItems.region_id == regionId)
								{
									if (activeInventoryStream.inventory_id == inventoryStreamItems.inventory_id)
									{
										activeInventoryStream.EndInventoryStream();
										
										// RESPOND WITH ACKNOWLEDGMENT TO END CONTAINER INVENTORY STREAM
										isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
									}
								}
							}
						}
					} break;
					case MESSAGE_TYPE.SYNC_PATROL_STATE:
					{
						var patrolState = payload;
						if (!is_undefined(patrolState))
						{
							if (global.NetworkRegionObjectHandlerRef.SyncRegionPatrolState(patrolState))
							{
								// RESPOND WITH ACKNOWLEDGMENT TO END PATROL STATE CHANGE
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();	
							}
						}
					} break;
					case MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA:
					{
						var patrolsSnapshotData = payload;
						if (!is_undefined(patrolsSnapshotData))
						{
							// PATROL SNAPSHOT DATA IS ROUTINE AND ONLY LATEST MESSAGE TAKES EFFECT
							// NO GUARANTEE FOR DELIVERY REQUIRED
							isPacketHandled = global.NetworkRegionObjectHandlerRef.SyncRegionPatrolsSnapshot(patrolsSnapshotData);
						}
					} break;
					case MESSAGE_TYPE.PATROL_ACTION_ROB:
					{
						var patrolActionData = payload;
						if (!is_undefined(patrolActionData))
						{
							if (global.NetworkRegionObjectHandlerRef.SyncPatrolActionRob(patrolActionData))
							{
								// RESPOND WITH ACKNOWLEDGMENT TO PATROL ACTION ROB
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.REQUEST_SCOUT_LIST:
					{
						var parsedAvailableInstances = payload;
						var scoutListWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenterScoutList);
						if (!is_undefined(scoutListWindow))
						{
							var scoutListElement = scoutListWindow.GetChildElementById("ScoutList");
							if (!is_undefined(scoutListElement))
							{
								scoutListElement.UpdateDataCollection(parsedAvailableInstances);
										
								// HIDE LOADING ICON
								var scoutListLoadingElement = scoutListWindow.GetChildElementById("ScoutListLoading");
								if (!is_undefined(scoutListLoadingElement))
								{
									scoutListLoadingElement.isVisible = false;
								}
								// RESPOND WITH ACKNOWLEDGMENT TO END INSTANCE LIST REQUEST
								isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
							}
						}
					} break;
					case MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM:
					{
						var operationsCenterWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenter);
						if (!is_undefined(operationsCenterWindow))
						{
							// CLOSE OPERATION SCOUT LIST WINDOW
							if (global.GUIStateHandlerRef.IsCurrentGUIStateGameWindowOpen(GAME_WINDOW.OperationsCenterScoutList))
							{
								// TODO: Fix logic to close scout list even if console/other windows are open
								global.GUIStateHandlerRef.RequestCloseCurrentGUIState();
							}
							// SET ACTIVE OPERATIONS SCOUT STREAM
							global.MapDataHandlerRef.active_operations_scout_stream = global.MapDataHandlerRef.target_scout_region;
							// START SCOUTING DRONE POSITION SYNC TIMER
							global.MapDataHandlerRef.scouting_drone_position_sync_timer.StartTimer();
							// START MAP UPDATE
							global.MapDataHandlerRef.is_dynamic_data_updating = true;
							global.MapDataHandlerRef.map_update_timer.StartTimer();
							// RESPOND WITH ACKNOWLEDGMENT TO START OPERATIONS SCOUT STREAM
							isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
						}
					} break;
					case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
					{
						var regionSnapshot = payload;
						if (!is_undefined(regionSnapshot))
						{
							// SYNC DYNAMIC REGION MAP DATA
							global.MapDataHandlerRef.SyncDynamicMapData(regionSnapshot);
							// NO NEED FOR SEPARATE ACKNOWLEDGMENT WHILE STREAMING
							isPacketHandled = true;
						}
					} break;
					case MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM:
					{
						// RESET OPERATIONS SCOUT STREAM
						global.MapDataHandlerRef.ResetActiveOperationsScoutStream();
						
						// REQUEST GUI STATE RESET
						global.GUIStateHandlerRef.RequestGUIStateReset();
						
						// RESPOND WITH ACKNOWLEDGMENT TO END OPERATIONS SCOUT STREAM REQUEST
						isPacketHandled = global.NetworkHandlerRef.QueueAcknowledgmentResponse();
					} break;
					case MESSAGE_TYPE.SYNC_SCOUTING_DRONE_DATA:
					{
						var scoutingDroneInstanceObject = payload;
						if (!is_undefined(scoutingDroneInstanceObject))
						{
							global.NotificationHandlerRef.AddNotification(
								new Notification(
									sprIconDroneEnterRegion, "Scouting drone arrived",
									"Scouting drone entered the area",
									NOTIFICATION_TYPE.Popup
								)
							);
							isPacketHandled = global.NetworkRegionObjectHandlerRef.SpawnScoutingDrone(scoutingDroneInstanceObject);
						}
					} break;
					case MESSAGE_TYPE.SCOUTING_DRONE_DATA_POSITION:
					{
						var scoutingDroneData = payload;
						if (!is_undefined(scoutingDroneData))
						{
							isPacketHandled = global.NetworkRegionObjectHandlerRef.UpdateScoutingDronePosition(scoutingDroneData);
						}
					} break;
					case MESSAGE_TYPE.DESTROY_SCOUTING_DRONE_DATA:
					{
						var scoutingDroneData = payload;
						if (!is_undefined(scoutingDroneData))
						{
							global.NotificationHandlerRef.AddNotification(
								new Notification(
									sprIconDroneLeaveRegion, "Scouting drone disappeared",
									"Scouting drone left the area",
									NOTIFICATION_TYPE.Popup
								)
							);
							isPacketHandled = global.NetworkRegionObjectHandlerRef.DestroyScoutingDrone(scoutingDroneData);
						}
					} break;
					default:
					{
						var errorMessage = string("Missing implementation for message type {0}", messageType);
						var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CLIENT_ERROR);
						var networkPacket = new NetworkPacket(
							networkPacketHeader,
							{
								error: errorMessage
							},
							PACKET_PRIORITY.DEFAULT,
							AckTimeoutFuncResend
						);
						throw errorMessage;
					}
				}
			} catch (error)
			{
				show_debug_message(error);
				show_message(error);
			}
		}
		return isPacketHandled;
	}
}