function NetworkPacketParser() constructor
{
	static ParsePacket = function(_msgRaw, _networkBufferCompress)
	{
		var parsedNetworkPacket = undefined;
		try
		{
			buffer_seek(_msgRaw, buffer_seek_start, 0);
			var parsedMessageType = buffer_read(_msgRaw, buffer_u8);
			var parsedHeader = new NetworkPacketHeader(parsedMessageType);
			var deliveryPolicy = (global.NetworkPacketDeliveryPolicies[? parsedMessageType] ??
									global.NetworkPacketDeliveryPolicies[? MESSAGE_TYPE.ENUM_LENGTH]);
			
			var deleteBufferAfterward = false;
			var msg = _msgRaw;
			if (deliveryPolicy.compress)
			{
				// DECOMPRESS MESSAGE BUFFER
				buffer_copy(
					_msgRaw, buffer_sizeof(buffer_u8), buffer_get_size(_msgRaw) - buffer_sizeof(buffer_u8),
					_networkBufferCompress, 0
				);
				msg = buffer_decompress(_networkBufferCompress);
				buffer_seek(msg, buffer_seek_start, 0);
				deleteBufferAfterward = true;
			}
			
			if (buffer_exists(msg))
			{
				// PARSE HEADER
				if (!deliveryPolicy.minimal_header)
				{
					var parsedClientId = buffer_read(msg, buffer_string);
					var parsedSequenceNumber = buffer_read(msg, buffer_u8);
					var parsedAckCount = buffer_read(msg, buffer_u8);
				
				    parsedHeader.client_id = parsedClientId;
					parsedHeader.sequence_number = parsedSequenceNumber;
				    parsedHeader.ack_count = parsedAckCount;
					
					ClearDSListAndDeleteValues(parsedHeader.ack_range);
					for (var i = 0; i < parsedAckCount; i++)
					{
						var acknowledgmentId = buffer_read(msg, buffer_u8);
						ds_list_add(parsedHeader.ack_range, acknowledgmentId);
					}
				}
			
				// PARSE PAYLOAD
				var parsedPayload = ParsePayload(parsedMessageType, msg);
				parsedNetworkPacket = new NetworkPacket(parsedHeader, parsedPayload);
				
				// DELETE TEMP NETWORK BUFFER AFTER READING
				if (deleteBufferAfterward)
				{
					buffer_delete(msg);
				}
			}
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
			// CHECK IF PACKET HAS PAYLOAD
			if (buffer_tell(_msg) < buffer_get_size(_msg))
			{
				switch (_messageType)
				{
					case MESSAGE_TYPE.REMOTE_CONNECTED_TO_HOST:
					{
						var parsedRemoteClientId = buffer_read(_msg, buffer_string);
						var parsedRemotePlayerTag = buffer_read(_msg, buffer_string);
						parsedPayload = new RemotePlayerInfo(
							parsedRemoteClientId,
							parsedRemotePlayerTag
						);
					} break;
					case MESSAGE_TYPE.PING:
					{
						parsedPayload = buffer_read(_msg, buffer_u32);
					} break;
					case MESSAGE_TYPE.REMOTE_DISCONNECT_FROM_HOST:
					{
						var parsedRemoteClientId = buffer_read(_msg, buffer_string);
						var parsedRemotePlayerTag = buffer_read(_msg, buffer_string);
						parsedPayload = new RemotePlayerInfo(
							parsedRemoteClientId,
							parsedRemotePlayerTag
						);
					} break;
					case MESSAGE_TYPE.INVALID_REQUEST:
					{
						var parsedRequestAction = buffer_read(_msg, buffer_u8);
						var parsedOriginalMessageType = buffer_read(_msg, buffer_u8);
						var parsedInvalidationMessage = buffer_read(_msg, buffer_string);
						parsedPayload = new InvalidRequestInfo(
							parsedRequestAction,
							parsedOriginalMessageType,
							parsedInvalidationMessage
						);
					} break;
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
							var regionStruct = parsedStruct[$ "region"] ?? undefined;
							var parsedRegion = ParseJSONStructToRegion(regionStruct);
							
							var parsedScoutingDrone = undefined;
							var scoutingDroneStruct = parsedStruct[$ "scouting_drone"] ?? undefined;
							if (!is_undefined(scoutingDroneStruct))
							{
								var parsedPosition = ParseJSONStructToVector2(scoutingDroneStruct[$ "position"] ?? undefined);
								parsedScoutingDrone = new InstanceObject(
									object_get_sprite(objDrone),
									objDrone,
									parsedPosition
								);
							}
							parsedPayload = {
								region: parsedRegion,
								scouting_drone: parsedScoutingDrone
							}
						}
					} break;
					case MESSAGE_TYPE.SYNC_INSTANCE_OWNER:
					{
						var ownerClientId = buffer_read(_msg, buffer_string)
						parsedPayload = ownerClientId;
					} break;
					case MESSAGE_TYPE.INSTANCE_SNAPSHOT_DATA:
					{
						parsedPayload = ParseRegionSnapshotPayload(_msg);
					} break;
					case MESSAGE_TYPE.REMOTE_ENTERED_THE_INSTANCE:
					{
						var parsedRemoteClientId = buffer_read(_msg, buffer_string);
						var parsedRemotePlayerTag = buffer_read(_msg, buffer_string);
						parsedPayload = new RemotePlayerInfo(
							parsedRemoteClientId,
							parsedRemotePlayerTag
						);
					} break;
					case MESSAGE_TYPE.REMOTE_DATA_MOVEMENT_INPUT:
					{
			            var parsedDeviceInputCompress = buffer_read(_msg, buffer_u8);
						
			            var parsedKeyRight = (parsedDeviceInputCompress >= 8);
			            if (parsedKeyRight) parsedDeviceInputCompress -= 8;
			            var parsedKeyLeft = (parsedDeviceInputCompress >= 4);
			            if (parsedKeyLeft) parsedDeviceInputCompress -= 4;
			            var parsedKeyDown = (parsedDeviceInputCompress >= 2);
			            if (parsedKeyDown) parsedDeviceInputCompress -= 2;
			            var parsedKeyUp = (parsedDeviceInputCompress >= 1);
			            if (parsedKeyUp) parsedDeviceInputCompress -= 1;
						
						var parsedNetworkId = buffer_read(_msg, buffer_string);
						
						var emptyInstanceObject = new InstanceObject(
							undefined, objPlayer, undefined
						);
						emptyInstanceObject.network_id = parsedNetworkId;
						emptyInstanceObject.device_input_movement.key_up = parsedKeyUp;
						emptyInstanceObject.device_input_movement.key_down = parsedKeyDown;
						emptyInstanceObject.device_input_movement.key_left = parsedKeyLeft;
						emptyInstanceObject.device_input_movement.key_right = parsedKeyRight;
						
						parsedPayload = emptyInstanceObject;
					} break;
					case MESSAGE_TYPE.REMOTE_LEFT_THE_INSTANCE:
					{
						var parsedRemoteClientId = buffer_read(_msg, buffer_string);
						var parsedRemotePlayerTag = buffer_read(_msg, buffer_string);
						parsedPayload = new RemotePlayerInfo(
							parsedRemoteClientId,
							parsedRemotePlayerTag
						);
					} break;
					case MESSAGE_TYPE.REMOTE_RETURNED_TO_CAMP:
					{
						var parsedRemoteClientId = buffer_read(_msg, buffer_string);
						var parsedRemotePlayerTag = buffer_read(_msg, buffer_string);
						parsedPayload = new RemotePlayerInfo(
							parsedRemoteClientId,
							parsedRemotePlayerTag
						);
					} break;
					case MESSAGE_TYPE.REQUEST_PLAYER_LIST:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							var parsedPlayerListStructArray = parsedStruct[$ "player_list"] ?? undefined;
							var parsedPlayerList = ds_list_create();
							ParseJSONStructToList(parsedPlayerList, parsedPlayerListStructArray, ParseJSONStructToPlayerListInfo);
							parsedPayload = parsedPlayerList;
						}
					} break;
					case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							var parsedAvailableInstanceStructArray = parsedStruct[$ "available_instances"] ?? undefined;
							var parsedAvailableInstances = ds_list_create();
							ParseJSONStructToList(parsedAvailableInstances, parsedAvailableInstanceStructArray, ParseJSONStructToAvailableInstance);
							parsedPayload = parsedAvailableInstances;
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
							parsedPayload = new NetworkInventoryStreamItems(
								parsedStruct[$ "instance_id"],
								parsedStruct[$ "inventory_id"],
								parsedItems
							);
						}
					} break;
					case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
					{
						var parsedRegionId = buffer_read(_msg, buffer_u32);
						var parsedInventoryId = buffer_read(_msg, buffer_string);
						parsedPayload = new NetworkInventoryStreamItems(
							parsedRegionId,
							parsedInventoryId,
							[]
						);
					} break;
					case MESSAGE_TYPE.SYNC_PATROL_STATE:
					{
						var parsedRegionId = buffer_read(_msg, buffer_u32);
						var parsedPatrolId = buffer_read(_msg, buffer_u8);
						var parsedAIState = buffer_read(_msg, buffer_u8);
						var parsedRouteProgress = buffer_read(_msg, buffer_f32);
						var parsedPositionX = buffer_read(_msg, buffer_u32);
						var parsedPositionY = buffer_read(_msg, buffer_u32);
						var parsedTargetNetworkId = buffer_read(_msg, buffer_string);
						
						var parsedPosition = ScaleIntValuesToFloatVector2(parsedPositionX, parsedPositionY);
						parsedPayload = new PatrolState(
							parsedRegionId,
							parsedPatrolId,
							parsedAIState,
							parsedRouteProgress,
							parsedPosition,
							parsedTargetNetworkId
						);
					} break;
					case MESSAGE_TYPE.REQUEST_SCOUT_LIST:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							var parsedAvailableInstanceStructArray = parsedStruct[$ "available_instances"] ?? undefined;
							var parsedAvailableInstances = ds_list_create();
							ParseJSONStructToList(parsedAvailableInstances, parsedAvailableInstanceStructArray, ParseJSONStructToAvailableInstance);
							parsedPayload = parsedAvailableInstances;
						}
					} break;
					case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
					{
						parsedPayload = ParseRegionSnapshotPayload(_msg);
					} break;
					case MESSAGE_TYPE.SYNC_SCOUTING_DRONE_DATA:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							var parsedPosition = ParseJSONStructToVector2(parsedStruct[$ "position"] ?? undefined);
							parsedPayload = new InstanceObject(
								object_get_sprite(objDrone),
								objDrone,
								parsedPosition
							);
						}
					} break;
					case MESSAGE_TYPE.SCOUTING_DRONE_DATA_POSITION:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							parsedPayload = ParseJSONStructToScoutingDroneData(parsedStruct);
						}
					} break;
					case MESSAGE_TYPE.DESTROY_SCOUTING_DRONE_DATA:
					{
						var payloadString = buffer_read(_msg, buffer_string);
						var parsedStruct = json_parse(payloadString);
						if (parsedStruct != EMPTY_STRUCT)
						{
							parsedPayload = ParseJSONStructToScoutingDroneData(parsedStruct);
						}
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
	
	static ParseRegionSnapshotPayload = function(_msg)
	{
		var parsedRegionSnapshot = undefined;
		var parsedRegionId = buffer_read(_msg, buffer_u32);
		var parsedPlayerCount = buffer_read(_msg, buffer_u8);
		var parsedPatrolCount = buffer_read(_msg, buffer_u8);
						
		// PARSE LOCAL PLAYERS
		var localPlayers = [];
		repeat(parsedPlayerCount)
		{
			var parsedNetworkId = buffer_read(_msg, buffer_string);
			var parsedPositionX = buffer_read(_msg, buffer_u32);
			var parsedPositionY = buffer_read(_msg, buffer_u32);
			var parsedPosition = ScaleIntValuesToFloatVector2(parsedPositionX, parsedPositionY);
			var playerData = new PlayerData(
				parsedNetworkId,
				"RemotePlayer",
				parsedPosition
			);
			array_push(localPlayers, playerData);
		}
		
		// PARSE LOCAL PATROS
		var localPatrols = [];
		repeat(parsedPatrolCount)
		{
			var parsedPatrolId = buffer_read(_msg, buffer_u8);
			var parsedRouteProgress = buffer_read(_msg, buffer_u16);
			var scaledRouteProgress = ScaleIntPercentToFloat(parsedRouteProgress);
			var parsedPositionX = buffer_read(_msg, buffer_u32);
			var parsedPositionY = buffer_read(_msg, buffer_u32);
			var parsedPosition = ScaleIntValuesToFloatVector2(parsedPositionX, parsedPositionY);
			var patrol = new Patrol(
				parsedPatrolId,
				undefined,
				undefined,
				scaledRouteProgress
			);
			patrol.position = parsedPosition;
			array_push(localPatrols, patrol);
		}
		
		parsedRegionSnapshot = new NetworkRegionSnapshot(
			parsedRegionId,
			localPlayers,
			localPatrols
		);
		return parsedRegionSnapshot;
	}
}