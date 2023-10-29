function NetworkPacketParser() constructor
{
	static ParsePacket = function(_msg)
	{
		var parsedNetworkPacket = undefined;
		try
		{
			buffer_seek(_msg, buffer_seek_start, 0);
			var messageType = buffer_read(_msg, buffer_u8);
			var clientId = buffer_read(_msg, buffer_string);
			var acknowledgmentId = buffer_read(_msg, buffer_s8);
			var parsedHeader = new NetworkPacketHeader(messageType, clientId);
			if (acknowledgmentId != -1)
			{
				parsedHeader.SetAcknowledgmentId(acknowledgmentId);
			}
			
			var parsedPayload = ParsePayload(messageType, _msg);
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
		}
		return parsedPayload;
	}
}