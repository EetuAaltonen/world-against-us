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
						var worldMapFastTravelInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, worldMapFastTravelInfo.source_region_id);
						// SET SAME SOURCE AND DESTINATION IF NEW INSTANCE IS REQUESTED
						buffer_write(_networkBuffer, buffer_u32, worldMapFastTravelInfo.destination_region_id ?? worldMapFastTravelInfo.source_region_id);
						buffer_write(_networkBuffer, buffer_text, worldMapFastTravelInfo.destination_room_index);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
					{
						var containerContentInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_s32, containerContentInfo.content_count);
						buffer_write(_networkBuffer, buffer_text, containerContentInfo.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
					{
						var networkInventoryStream = _networkPacketPayload;
						var scaledInstancePosition = ScaleFloatValuesToIntVector2(
							networkInventoryStream.target_instance_position.X,
							networkInventoryStream.target_instance_position.Y
						);
						buffer_write(_networkBuffer, buffer_u32, scaledInstancePosition.X);
						buffer_write(_networkBuffer, buffer_u32, scaledInstancePosition.Y);
						buffer_write(_networkBuffer, buffer_u8, networkInventoryStream.stream_item_limit);
						buffer_write(_networkBuffer, buffer_bool, networkInventoryStream.is_stream_sending);
						buffer_write(_networkBuffer, buffer_u16, networkInventoryStream.stream_current_index);
						buffer_write(_networkBuffer, buffer_u16, networkInventoryStream.stream_end_index);
						buffer_write(_networkBuffer, buffer_text, networkInventoryStream.target_container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM:
					{
						var containerInventoryActionInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.col);
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.row);
						buffer_write(_networkBuffer, buffer_bool, containerInventoryActionInfo.is_known);
						buffer_write(_networkBuffer, buffer_text, containerInventoryActionInfo.container_id);
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