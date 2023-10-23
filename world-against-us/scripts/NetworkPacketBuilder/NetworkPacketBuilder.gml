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
					var networkPacketSize = 0;
					networkPacketSize += WritePacketHeader(_networkBuffer, _networkPacket.header);
					if (networkPacketSize <= 0) throw ("Failed to write the packet header")
					networkPacketSize += WritePacketPayload(_networkBuffer, _networkPacket.header.message_type, _networkPacket.payload);
					
					// TODO: MOVE THIS UNDER SEND FUNCTION AND CALCULATE kbs
					show_debug_message(string("Network packet size: {0}kb", networkPacketSize * 0.001));
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
		var writtenHeaderSize = 0;
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
				
				writtenHeaderSize = 1 /*Message type*/ + string_byte_length(clientId);
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return writtenHeaderSize;
	}
	
	static WritePacketPayload = function(_networkBuffer, _networkMessageType, _networkPacketPayload)
	{
		var writtenPayloadSize = 0;
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
					} break;
					default:
					{
						var jsonString = json_stringify(_networkPacketPayload);
						buffer_write(_networkBuffer, buffer_text, jsonString);
						writtenPayloadSize = string_byte_length(jsonString);
					}
				}
			}
		} catch (error)
		{
			show_debug_message(error);
			show_message(error);
		}
		return writtenPayloadSize;
	}
}