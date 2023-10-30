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
							default:
							{
								show_debug_message(string("Unknown message type {0} to handle", messageType));
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