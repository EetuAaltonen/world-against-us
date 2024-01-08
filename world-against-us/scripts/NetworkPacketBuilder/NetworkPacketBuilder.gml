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
				var sequenceNumber = _networkPacketHeader.sequence_number;
				var ackCount = _networkPacketHeader.ack_count;
				var ackRange = _networkPacketHeader.ack_range;
				buffer_seek(_networkBuffer, buffer_seek_start, 0);
				buffer_write(_networkBuffer, buffer_u8, messageType);
				buffer_write(_networkBuffer, buffer_text, clientId);
				buffer_write(_networkBuffer, buffer_u8, sequenceNumber);
				buffer_write(_networkBuffer, buffer_u8, ackCount);
				for (var i = 0; i < ackCount; i++)
				{
					var acknowledgmentId = ackRange[| i] ?? 0;
					buffer_write(_networkBuffer, buffer_u8, acknowledgmentId);
				}
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
					case MESSAGE_TYPE.CONNECT_TO_HOST:
					{
						var playerTag = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_text, playerTag);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PING:
					{
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.client_time);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PONG:
					{
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.server_time);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PLAYER_DATA_POSITION:
					{
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.X);
						buffer_write(_networkBuffer, buffer_u32, _networkPacketPayload.Y);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT:
					{
						var deviceInputCompress = 0;
						if (_networkPacketPayload.key_up) deviceInputCompress += 1;
						if (_networkPacketPayload.key_down) deviceInputCompress += 2;
						if (_networkPacketPayload.key_left) deviceInputCompress += 4;
						if (_networkPacketPayload.key_right) deviceInputCompress += 8;
						buffer_write(_networkBuffer, buffer_s8, deviceInputCompress);
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
						var networkContainerContentRequest = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, networkContainerContentRequest.region_id);
						buffer_write(_networkBuffer, buffer_text, networkContainerContentRequest.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
					{
						var networkInventoryStream = _networkPacketPayload;
						// TODO: Add region ID to validate the request on server
						// + to CONTAINER_INVENTORY_STREAM
						buffer_write(_networkBuffer, buffer_u8, networkInventoryStream.stream_item_limit);
						buffer_write(_networkBuffer, buffer_bool, networkInventoryStream.is_stream_sending);
						buffer_write(_networkBuffer, buffer_u16, networkInventoryStream.stream_current_index);
						buffer_write(_networkBuffer, buffer_u16, networkInventoryStream.stream_end_index);
						buffer_write(_networkBuffer, buffer_text, networkInventoryStream.inventory_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
					{
						// TODO: Add region ID to validate the request on server
						var networkInventoryStreamItems = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, networkInventoryStreamItems.region_id);
						buffer_write(_networkBuffer, buffer_text, networkInventoryStreamItems.inventory_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM:
					{
						// TODO: Add region ID to validate the request on server
						var containerInventoryActionInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.col);
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.row);
						buffer_write(_networkBuffer, buffer_bool, containerInventoryActionInfo.is_known);
						buffer_write(_networkBuffer, buffer_text, containerInventoryActionInfo.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM:
					{
						// TODO: Add region ID to validate the request on server
						var containerInventoryActionInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.col);
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.row);
						buffer_write(_networkBuffer, buffer_bool, containerInventoryActionInfo.is_rotated);
						buffer_write(_networkBuffer, buffer_text, containerInventoryActionInfo.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM:
					{
						// TODO: Add region ID to validate the request on server
						var containerInventoryActionInfo = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.col);
						buffer_write(_networkBuffer, buffer_u8, containerInventoryActionInfo.source_grid_index.row);
						buffer_write(_networkBuffer, buffer_text, containerInventoryActionInfo.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.RELEASE_CONTAINER_CONTENT:
					{
						var networkContainerContentRequest = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, networkContainerContentRequest.region_id);
						buffer_write(_networkBuffer, buffer_text, networkContainerContentRequest.container_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PATROL_STATE:
					{
						var patrolState = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, patrolState.region_id);
						buffer_write(_networkBuffer, buffer_u8, patrolState.patrol_id);
						buffer_write(_networkBuffer, buffer_u8, patrolState.ai_state);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA:
					{
						var patrolsDataProgressPosition = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, patrolsDataProgressPosition.region_id);
						var patrolCount = array_length(patrolsDataProgressPosition.local_patrols);
						buffer_write(_networkBuffer, buffer_u8, patrolCount);
						for (var i = 0; i < patrolCount; i++)
						{
							var patrolData = patrolsDataProgressPosition.local_patrols[@ i];
							buffer_write(_networkBuffer, buffer_u8, patrolData.patrol_id);
							buffer_write(_networkBuffer, buffer_u16, patrolData.route_progress);
							buffer_write(_networkBuffer, buffer_u32, patrolData.local_position.X);
							buffer_write(_networkBuffer, buffer_u32, patrolData.local_position.Y);
						}
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM:
					{
						var availableInstance = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, availableInstance.region_id);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
					{
						var scoutingDroneData = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, scoutingDroneData.region_id);
						buffer_write(_networkBuffer, buffer_u32, scoutingDroneData.position.X);
						buffer_write(_networkBuffer, buffer_u32, scoutingDroneData.position.Y);
						isPayloadWritten = true;
					} break;
					case MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM:
					{
						var scoutingDroneData = _networkPacketPayload;
						buffer_write(_networkBuffer, buffer_u32, scoutingDroneData.region_id);
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
				// RETURN TRUE WHEN PAYLOAD IS LEFT EMPTY WITHOUT AN ERROR
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