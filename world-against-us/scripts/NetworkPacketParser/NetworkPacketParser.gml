function NetworkPacketParser() constructor
{
	static ParsePacket = function(_msg)
	{
		var parsedNetworkPacket = undefined;
		try
		{
			buffer_seek(_msg, buffer_seek_start, 0);
			var parsedMessageType = buffer_read(_msg, buffer_u8);
			var parsedClientId = buffer_read(_msg, buffer_string);
			var parsedAcknowledgmentId = buffer_read(_msg, buffer_s8);
			var parsedHeader = new NetworkPacketHeader(parsedMessageType);
			// SET CLIENT ID
			parsedHeader.SetClientId(parsedClientId);
			// SET ACKNOWLEDGMENT
			parsedHeader.SetAcknowledgmentId(parsedAcknowledgmentId);
			
			var parsedPayload = ParsePayload(parsedMessageType, _msg);
			parsedNetworkPacket = new NetworkPacket(parsedHeader, parsedPayload);
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return parsedNetworkPacket;
	}
	
	static ParsePayload = function(_messageType, _msg)
	{
		var parsedPayload = undefined;
		try
		{
			// SET BUFFER TO THE INDEX BEFORE THE PAYLOAD
			buffer_seek(_msg, buffer_seek_relative, 0);
			switch (_messageType)
			{
				case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
				{
					var parsedSourceRegionId = buffer_read(_msg, buffer_u32);
					var parsedDestinationRegionId = buffer_read(_msg, buffer_u32);
					var parsedDestinationRoomIndex = buffer_read(_msg, buffer_string);
					parsedPayload = new WorldMapFastTravelInfo(
						parsedSourceRegionId,
						parsedDestinationRegionId,
						parsedDestinationRoomIndex
					);
				} break;
				case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
				{
					var parsedContentCount = buffer_read(_msg, buffer_s32);
					var parsedContainerId = buffer_read(_msg, buffer_string);
					parsedPayload = new ContainerContentInfo(
						parsedContainerId,
						parsedContentCount
					);
				} break;
				case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
				{
					var payloadString = buffer_read(_msg, buffer_string);
					var parsedStruct = json_parse(payloadString);
					if (parsedStruct != EMPTY_STRUCT)
					{
						var parsedItemStructArray = parsedStruct[$ "items"] ?? undefined;
						var parsedItems = ParseJSONStructToArray(parsedItemStructArray, ParseJSONStructToItem);
						parsedPayload = new NetworkInventoryStreamItems(parsedItems);
					}
				} break;
				default:
				{
					var payloadString = buffer_read(_msg, buffer_string);
					parsedPayload = json_parse(payloadString);
				}
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
			parsedPayload = undefined;
		}
		return parsedPayload;
	}
}