function NetworkPacketBuilder() constructor
{
	static CreatePacket = function(_networkBuffer, _networkPacket)
	{
		var isPacketCreated = false;
		try
		{
			if (buffer_exists(_networkBuffer))
			{
				if (!is_undefined(_networkPacket))
				{
					if (!WritePacketHeader(_networkBuffer, _networkPacket.header))
					{
						throw ("Failed to write the packet header");
					}
					if (!WritePacketPayload(_networkBuffer, _networkPacket.header.message_type, _networkPacket.payload))
					{
						throw ("Failed to write the packet payload");
					}
					isPacketCreated = true;
				}
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isPacketCreated;
	}
	
	static WritePacketHeader = function(_networkBuffer, _networkPacketHeader)
	{
		var isHeaderWritten = false;
		try
		{
			if (!is_undefined(_networkPacketHeader))
			{
				var messageType = _networkPacketHeader.message_type;
				var clientId = _networkPacketHeader.client_id ?? UNDEFINED_UUID;
				var acknowledgmentId = _networkPacketHeader.acknowledgment_id;
				buffer_seek(_networkBuffer, buffer_seek_start, 0);
				buffer_write(_networkBuffer, buffer_u8, messageType);
				buffer_write(_networkBuffer, buffer_text, clientId);
				buffer_write(_networkBuffer, buffer_s8, acknowledgmentId);
				
				isHeaderWritten = true;
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isHeaderWritten;
	}
	
	static WritePacketPayload = function(_networkBuffer, _networkMessageType, _networkPacketPayload)
	{
		var isPayloadWritten = false;
		try
		{
			if (!is_undefined(_networkPacketPayload))
			{
				buffer_seek(_networkBuffer, buffer_seek_relative, 0);
				
				switch (_networkMessageType)
				{
					case MESSAGE_TYPE.DATA_PLAYER_POSITION:
					{
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.X);
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.Y);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
					{
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.source_region_id);
						// SET SAME SOURCE AND DESTINATION IF NEW INSTANCE IS REQUESTED
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.destination_region_id ?? _networkPacketPayload.source_region_id);
						buffer_write(_networkBuffer, buffer_text, _networkPacketPayload.destination_room_index);
						isPayloadWritten = true;
					} break;
					default:
					{
						var jsonString = json_stringify(_networkPacketPayload);
						buffer_write(_networkBuffer, buffer_text, jsonString);
						isPayloadWritten = true;
					}
				}
			} else {
				isPayloadWritten = true;
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return isPayloadWritten;
	}
}