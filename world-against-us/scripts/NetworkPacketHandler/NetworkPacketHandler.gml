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
					var payloadStruct = json_parse(payload);
					switch (messageType)
					{
						case MESSAGE_TYPE.REQUEST_JOIN_GAME:
						{
							var regionId = payloadStruct[$ "instance_id"] ?? undefined;
							var roomIndex = payloadStruct[$ "room_index"] ?? undefined;
							var ownerClient = payloadStruct[$ "owner_client"] ?? undefined;
							
							global.NetworkHandlerRef.region_id = regionId;
							global.NetworkHandlerRef.room_index = roomIndex;
							global.NetworkHandlerRef.owner_client = ownerClient;

							isPacketHandled = true;
						} break;
						case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
						{
							var instanceStructArray = payloadStruct[$ "available_instances"] ?? [];
							var worldMapWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.WorldMap);
							if (!is_undefined(worldMapWindow))
							{
								var instanceListElement = worldMapWindow.GetChildElementById("InstanceList");
								if (!is_undefined(instanceListElement))
								{
									var parsedInstances = ParseJSONStructToList(instanceStructArray, ParseJSONStructToAvailableInstance);
									instanceListElement.UpdateDataCollection(parsedInstances);
								}
							}
						}
						default:
						{
							show_debug_message(string("Unknown message type {0} to handle", messageType));
						}
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