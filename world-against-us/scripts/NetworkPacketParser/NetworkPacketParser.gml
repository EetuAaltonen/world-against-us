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
			var parsedSequenceNumber = buffer_read(_msg, buffer_u8);
			var parsedAckCount = buffer_read(_msg, buffer_u8);
			
			var parsedHeader = new NetworkPacketHeader(parsedMessageType);
		    parsedHeader.client_id = parsedClientId;
			parsedHeader.sequence_number = parsedSequenceNumber;
		    parsedHeader.ack_count = parsedAckCount;
		    ds_list_clear(parsedHeader.ack_range);
			for (var i = 0; i < parsedAckCount; i++)
			{
				var acknowledgmentId = buffer_read(_msg, buffer_u8);
				ds_list_add(parsedHeader.ack_range, acknowledgmentId);
			}
			
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
			// CHECK IF PACKET HAS PAYLOAD
			if (buffer_tell(_msg) < buffer_get_size(_msg))
			{
				switch (_messageType)
				{
					case MESSAGE_TYPE.REQUEST_JOIN_GAME:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							parsedPayload = ParseJSONStructToJoinGameRequest(parsedStruct);
						}
					} break;
					case MESSAGE_TYPE.SYNC_WORLD_STATE:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							parsedPayload = ParseJSONStructToWorldStateSync(parsedStruct);
						}
					} break;
					case MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER:
					{
						parsedPayload = buffer_read(_msg, buffer_u8);
					} break;
					case MESSAGE_TYPE.SYNC_INSTANCE:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							parsedPayload = ParseJSONStructToRegion(parsedStruct);
						}
					} break;
					case MESSAGE_TYPE.REQUEST_PLAYER_LIST:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							var parsedPlayerListStructArray = parsedStruct[$ "player_list"] ?? undefined;
							var parsedPlayerList = ParseJSONStructToList(parsedPlayerListStructArray, ParseJSONStructToPlayerListInfo);
							parsedPayload = parsedPlayerList;
						}
					} break;
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
					case MESSAGE_TYPE.PATROL_STATE:
					{
						var parsedRegionId = buffer_read(_msg, buffer_u32);
						var parsedPatrolId = buffer_read(_msg, buffer_u8);
						var parsedAIState = buffer_read(_msg, buffer_u8);
						parsedPayload = new PatrolState(
							parsedRegionId,
							parsedPatrolId,
							parsedAIState
						);
					} break;
					default:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						parsedPayload = json_parse(payloadString);
					}
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