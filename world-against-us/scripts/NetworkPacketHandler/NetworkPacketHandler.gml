function NetworkPacketHandler() constructor
{
	static HandlePacket = function(networkPacket)
	{
		var isPacketHandled = false;
		if (!is_undefined(networkPacket))
		{
			try
			{
				var messageType = networkPacket.header.message_type;
				var payload = networkPacket.payload;
				if (!is_undefined(payload))
				{
					switch (messageType)
					{
						case MESSAGE_TYPE.REQUEST_JOIN_GAME:
						{
							var regionDataStruct = json_parse(payload);
							var regionId = regionDataStruct[$ "instance_id"] ?? undefined;
							var roomIndex = regionDataStruct[$ "room_index"] ?? undefined;
							var ownerClient = regionDataStruct[$ "owner_client"] ?? undefined;
							
							global.NetworkHandlerRef.region_id = regionId;
							global.NetworkHandlerRef.room_index = roomIndex;
							global.NetworkHandlerRef.owner_client = ownerClient;

							isPacketHandled = true;
						} break;
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