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
				if (!is_undefined(payload))
				{
					if (payload != EMPTY_STRUCT)
					{
						switch (messageType)
						{
							case MESSAGE_TYPE.REQUEST_JOIN_GAME:
							{
								var regionId = payload[$ "instance_id"] ?? undefined;
								var roomIndex = payload[$ "room_index"] ?? undefined;
								var ownerClient = payload[$ "owner_client"] ?? undefined;
							
								global.NetworkRegionHandlerRef.region_id = regionId;
								global.NetworkRegionHandlerRef.room_index = roomIndex;
								global.NetworkRegionHandlerRef.owner_client = ownerClient;

								isPacketHandled = true;
							} break;
							case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
							{
								var instanceStructArray = payload[$ "available_instances"] ?? [];
								var worldMapWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.WorldMap);
								if (!is_undefined(worldMapWindow))
								{
									var instanceListElement = worldMapWindow.GetChildElementById("InstanceList");
									if (!is_undefined(instanceListElement))
									{
										var parsedInstances = ParseJSONStructToList(instanceStructArray, ParseJSONStructToWorldInstance);
										instanceListElement.UpdateDataCollection(parsedInstances);
										
										// HIDE LOADING ICON
										var instanceListLoadingElement = worldMapWindow.GetChildElementById("InstanceListLoading");
										if (!is_undefined(instanceListLoadingElement))
										{
											instanceListLoadingElement.isVisible = false;
										}
										isPacketHandled = true;
									}
								}
							} break;
							case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
							{
								var destinationRegionId = payload.destination_region_id;
								if (!is_undefined(destinationRegionId))
								{
									var destinationRoomIndex = payload.destination_room_index;
									if (!is_undefined(destinationRoomIndex))
									{
										global.NetworkRegionHandlerRef.region_id = destinationRegionId;
										global.NetworkRegionHandlerRef.room_index = destinationRoomIndex;
										global.NetworkRegionHandlerRef.owner_client = undefined;
										switch(destinationRoomIndex)
										{
											// TODO: Request room change from objRoomLoader
											case ROOM_INDEX_CAMP:
											{
												isPacketHandled = true;
												room_goto(roomCamp);
											} break;
											case ROOM_INDEX_TOWN:
											{
												isPacketHandled = true;
												room_goto(roomTown);
											} break;
											default:
											{
												show_debug_message(string("Unknown destination room index to fast travel: {0}", destinationRoomIndex));
											}
										}
									}
								}
							} break;
							case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
							{
								var containerContentInfo = payload;
								var targetContainer = undefined;
								var containerCount = instance_number(objContainerParent);
								for (var i = 0; i < containerCount; ++i;)
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
									if (!is_undefined(targetContainer.lootTableTag))
									{
										if (!is_undefined(targetContainer.inventory))
										{
											var containerPosition = new Vector2(targetContainer.x, targetContainer.y);
											var activeInventoryStream = new NetworkInventoryStream(
												targetContainer.containerId,
												containerPosition,
												targetContainer.inventory,
												4, true, 
												targetContainer.inventory.GetItemCount()
											);
											// CLEAR INVENTORY
											targetContainer.inventory.ClearItems();
											// CHECK IF SERVER HAS CONTAINER CONTENT
											if (containerContentInfo.content_count == -1)
											{
												// GENERATE LOOT
												RollContainerLoot(targetContainer.lootTableTag, targetContainer.inventory);
											} else {
												activeInventoryStream.is_stream_sending = false;
											}
											// SET ACTIVE INVENTORY STREAM
											global.NetworkRegionObjectHandlerRef.active_inventory_stream = activeInventoryStream;
											
											// REQUEST CONTAINER INVENTORY DATA STREAM
											var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM);
											var networkPacket = new NetworkPacket(networkPacketHeader, activeInventoryStream);
											if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
											{
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
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
										var itemsStructArray = activeInventoryStream.FetchItemsToStream();
										var itemStructCount = array_length(itemsStructArray);
										if (itemStructCount > 0)
										{
											// CONTAINER INVENTORY STREAM
											var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
											var networkPacket = new NetworkPacket(networkPacketHeader, { items: itemsStructArray });
											if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
											{
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
										} else {
											// CONTAINER INVENTORY STREAM
											var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM);
											var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
											if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
											{
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
										}
									} else {
										// CONTAINER INVENTORY STREAM
										var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
										var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
										isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
									}
								}
							}break;
							case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
							{
								var activeInventoryStream = global.NetworkRegionObjectHandlerRef.active_inventory_stream;
								if (!is_undefined(activeInventoryStream))
								{
									if (activeInventoryStream.is_stream_sending)
									{
										var itemsStructArray = activeInventoryStream.FetchItemsToStream();
										var itemStructCount = array_length(itemsStructArray);
										if (itemStructCount > 0)
										{
											// CONTAINER INVENTORY STREAM
											var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
											var networkPacket = new NetworkPacket(networkPacketHeader, { items: itemsStructArray });
											if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
											{
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
										} else {
											// CONTAINER INVENTORY STREAM
											var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM);
											var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
											if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
											{
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
										}
									} else {
										// TODO: Parse items elsewhere
										var itemsStructArray = payload[$ "items"] ?? undefined;
										if (!is_undefined(itemsStructArray))
										{
											var parsedItems = ParseJSONStructToArray(itemsStructArray, ParseJSONStructToItem);
											if (array_length(parsedItems) > 0)
											{
												activeInventoryStream.target_inventory.AddMultipleItems(parsedItems);
												
												// CONTAINER INVENTORY STREAM
												var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
												var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
												isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
											}
										}
									}
								}
							} break;
							case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
							{
								var activeInventoryStream = global.NetworkRegionObjectHandlerRef.active_inventory_stream;
								if (!is_undefined(activeInventoryStream))
								{
									global.NetworkRegionObjectHandlerRef.ResetRegionObjectData();
								
									// HIDE CONTAINER INVENTORY LOADING ICON
									var lootContainerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.LootContainer);
									if (!is_undefined(lootContainerWindow))
									{
										var containerInventoryLoadingElement = lootContainerWindow.GetChildElementById("ContainerInventoryLoading");
										if (!is_undefined(containerInventoryLoadingElement))
										{
											containerInventoryLoadingElement.isVisible = false;
										}
									}
									
									if (!activeInventoryStream.is_stream_sending)
									{
										// CONTAINER INVENTORY STREAM
										var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM);
										var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
										isPacketHandled = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
									} else {
										isPacketHandled = true;
									}
								}
							} break;
							default:
							{
								if (messageType < MESSAGE_TYPE.ENUM_LENGTH)
								{
									// ACCEPT UNPROCESSED KNOWN MESSAGE TYPES
									isPacketHandled = true;
								} else {
									show_debug_message(string("Unknown message type {0} to handle", messageType));
								}
							}
						}
					} else {
						throw (string("Failed to handle network packet with messageType {0} with empty payload", messageType));
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