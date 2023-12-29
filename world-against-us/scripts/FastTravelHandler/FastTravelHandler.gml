function FastTravelHandler() constructor
{
	fast_travel_cache = ds_map_create();
	room_change_queue = undefined;
	
	static OnDestroy = function()
	{
		DestroyDSMapAndDeleteValues(fast_travel_cache);
		fast_travel_cache = undefined;
	}
	
	static RequestRoomChange = function(_destinationRoomIndex, _sourceRegionId = undefined, _destinationRegionId = undefined)
	{
		var isRoomChangeQueued = false;
		if (is_undefined(room_change_queue))
		{
			switch(_destinationRoomIndex)
			{
				case ROOM_INDEX_CAMP: { room_change_queue = roomCamp; } break;
				case ROOM_INDEX_TOWN: { room_change_queue = roomTown; } break;
				case ROOM_INDEX_OFFICE: { room_change_queue = roomOffice; } break;
				case ROOM_INDEX_LIBRARY: { room_change_queue = roomLibrary; } break;
				case ROOM_INDEX_MARKET: { room_change_queue = roomMarket; } break;
				case ROOM_INDEX_FOREST: { room_change_queue = roomForest; } break;
				default: {
					room_change_queue = undefined;
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, string("Unknown destination room index '{0}' to fast travel", _destinationRoomIndex));
				}
			}
			
			// CACHE FAST TRAVEL INFO AND LAST KNOWN POSITION
			if (!is_undefined(room_change_queue))
			{
				var cacheFastTravelInfo = new WorldMapFastTravelInfo(
					_sourceRegionId,
					_destinationRegionId,
					_destinationRoomIndex
				);
				if (instance_exists(global.InstancePlayer))
				{
					cacheFastTravelInfo.local_position = new Vector2(global.InstancePlayer.x, global.InstancePlayer.y);
				}
				if (!AddCacheFastTravelInfo(cacheFastTravelInfo))
				{
					global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, string("Unable to cache fast travel info with current room '{0}'", room_get_name(room)));
				}
				isRoomChangeQueued = true;
			}
		} else {
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, string("Room change request overflow, latest request with room index '{0}'", _destinationRoomIndex));
		}
		return isRoomChangeQueued;
	}
	
	static CheckRoomGotoQueueAndProceed = function()
	{
		if (!is_undefined(room_change_queue))
		{
			if (room_exists(room_change_queue))
			{
				var destinationRoom = room_change_queue;
				// RESET ROOM CHANGE QUEUE
				room_change_queue = undefined;
				// PROCEED ROOM GOTO
				room_goto(destinationRoom);
			}
		}
	}
	
	static RequestFastTravel = function(_fastTravelInfo)
	{
		var guiState = new GUIState(
			GUI_STATE.WorldMapFastTravelQueue, undefined, undefined,
			[
				CreateWindowWorldMapFastTravelQueue(GAME_WINDOW.WorldMapFastTravelQueue, -1)
			],
			GUI_CHAIN_RULE.OverwriteAll,
			undefined, undefined
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
		{
			// REQUEST FAST TRAVEL
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_FAST_TRAVEL);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				_fastTravelInfo,
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				show_debug_message("Failed to request fast travel");
			}
		}
	}
	
	static AddCacheFastTravelInfo = function(_fastTravelInfo)
	{
		var currentRoom = room_get_name(room);
		return ds_map_add(fast_travel_cache, currentRoom, _fastTravelInfo);	
	}
	
	static GetCacheFastTravelInfo = function(_roomIndex)
	{
		return fast_travel_cache[? _roomIndex];
	}
	
	static DeleteCacheFastTravelInfo = function(_roomIndex)
	{
		DeleteDSMapValueByKey(fast_travel_cache, _roomIndex);
	}
	
	static ClearAllCacheFastTravelInfo = function()
	{
		ClearDSMapAndDeleteValues(fast_travel_cache);
	}
}