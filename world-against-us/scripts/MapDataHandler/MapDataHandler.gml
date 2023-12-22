function MapDataHandler() constructor
{
	static_map_data = new MapData();
	dynamic_map_data = new MapData();
	
	is_dynamic_data_updating = false;
	map_update_timer = new Timer(TimerFromMilliseconds(300));
	
	target_scout_region = undefined;
	scouting_drone = undefined;
	
	static Update = function()
	{
		if (is_dynamic_data_updating)
		{
			if (map_update_timer.IsTimerStopped())
			{
				UpdateDynamicMapData();
				map_update_timer.StartTimer();
			} else {
				map_update_timer.Update();
			}
		}
	}
	
	static OnDestroy = function()
	{
		static_map_data.OnDestroy();
		static_map_data = undefined;
		dynamic_map_data.OnDestroy();
		dynamic_map_data = undefined;
	}
	
	static GetMapDataFileName = function(roomName)
	{
		return string("{0}_static_map.json", roomName);
	}
	
	static SetTargetScoutInstance = function(_availableInstance)
	{
		var isScoutInstanceSet = false;
		target_scout_region = _availableInstance;
		if (SetMapLocation(_availableInstance.room_index))
		{
			if (global.MultiplayerMode)
			{
				// REQUEST OPERATIONS SCOUTING START
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					_availableInstance,
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Unable to queue MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM");
				}
			} else {
				isScoutInstanceSet = true;
			}
		}
		return isScoutInstanceSet;
	}
	
	static SetMapLocation = function(_roomIndex)
	{
		var isMapLocationSet = false;
		var worldMapLocation = global.WorldMapLocationData[? _roomIndex];
		
		// INITIALIZE SCOUTING DRONE
		scouting_drone = new InstanceObject(sprDrone, objDrone, new Vector2(0, 0));
		
		var operationsCenterWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.OperationsCenter);
		if (!is_undefined(operationsCenterWindow))
		{
			var mapElement = operationsCenterWindow.GetChildElementById("MapElement");
			if (!is_undefined(mapElement))
			{
				// UPDATE STATIC MAP DATA
				if (UpdateStaticMapData(_roomIndex))
				{
					// SET MAP WINDOW ELEMENT LOCATION
					mapElement.target_map_location = worldMapLocation;
					// FORCE UPDATE FOLLOW TARGET
					mapElement.UpdateFollowTarget();
					
					isMapLocationSet = true;
				}
			}
		}
		return isMapLocationSet;
	}
	
	static UpdateStaticMapData = function(_roomIndex)
	{
		var isMapDataUpdated = false;
		// CLEAR STATIC MAP DATA
		ClearStaticMapData();
		
		var fileName = GetMapDataFileName(_roomIndex);
		isMapDataUpdated = ReadStaticMapDataFromFile(fileName);
		return isMapDataUpdated;
	}
	
	static UpdateDynamicMapData = function()
	{
		if (global.MultiplayerMode)
		{
			if (!is_undefined(target_scout_region))
			{
				// CONTAINER INVENTORY STREAM
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					target_scout_region,
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
			}
		} else {
			// TODO: Disabled during prototyping
			/*dynamic_map_data.icons = GenerateMapIcons(DYNAMIC_MAP_ICON);*/
			dynamic_map_data.SortIcons();
		}
	}
	
	static SyncDynamicMapData = function(_region)
	{
		// CLEAR ICONS
		dynamic_map_data.ClearIcons();
		
		var worldMapLocation = global.WorldMapLocationData[? _region.room_index];
		if (!is_undefined(worldMapLocation))
		{
			var var patrolPath = worldMapLocation.patrol_path;
			var mapIconStyle = global.MapIconStyleData[? "objBandit"];
			if (!is_undefined(patrolPath))
			{
				var patrolCount = array_length(_region.arrived_patrols);
				var banditSpriteSize = new Size(
					sprite_get_width(sprBandit),
					sprite_get_height(sprBandit)
				);
				for (var i = 0; i < patrolCount; i++)
				{
					var patrol = _region.arrived_patrols[@ i];
					var patrolPosition = new Vector2(
						path_get_x(patrolPath, patrol.route_progress),
						path_get_y(patrolPath, patrol.route_progress)
					);
					var positionWithOffset = new Vector2(
						patrolPosition.X - (banditSpriteSize.w * 0.5),
						patrolPosition.Y - (banditSpriteSize.h)
					);
					var mapIcon = new MapIcon(
						"objBandit",
						// TOP-LEFT CORNER TO DRAW RECTANGLE
						positionWithOffset,
						patrolPosition,
						banditSpriteSize,
						mapIconStyle,
						1
					);
					ds_list_add(dynamic_map_data.icons, mapIcon);
				}
				dynamic_map_data.SortIcons();
			}
		}
	}
	
	static GenerateStaticMapData = function()
	{
		var isMapDataGenerated = false;
		var roomName = room_get_name(room);
		var fileName = string("{0}{1}", "DEBUG/map_data/", GetMapDataFileName(roomName));
		
		static_map_data.icons = GenerateMapIcons(STATIC_MAP_ICON);
		try
		{
			var mapDataString = json_stringify(static_map_data.ToJSONStruct());
			var buffer = buffer_create(
				string_byte_length(mapDataString) + 1,
				buffer_fixed, 1
			);
			buffer_write(buffer, buffer_text, mapDataString);
			buffer_save(buffer, fileName);
			buffer_delete(buffer);
			
			isMapDataGenerated = true;
		} catch (error)
		{
			show_message(error);
			show_debug_message(error);
		}
		
		static_map_data.ClearIcons();
		return isMapDataGenerated;
	}
	
	static GenerateMapIcons = function(_mapIconType)
	{
		var mapIcons = ds_list_create();
		var isIconDynamic = (_mapIconType == DYNAMIC_MAP_ICON) ? true : false;
		
		for (var key = ds_map_find_first(global.MapIconStyleData); !is_undefined(key); key = ds_map_find_next(global.MapIconStyleData, key))
		{
			var iconStyle = global.MapIconStyleData[? key];
			if (!is_undefined(iconStyle))
			{
				if (iconStyle.is_dynamic == isIconDynamic)
				{
					// TODO: Fetch dynamic icons from new 'map_object_instances' list
					/*var styleObjectIndex = asset_get_index(iconStyle.object_name);
					var instanceCount = instance_number(styleObjectIndex);
					for (var i = 0; i < instanceCount; i++)
					{
						var instance = instance_find(styleObjectIndex, i);
						if (instance_exists(instance))
						{
							var objectName = object_get_name(instance.object_index);
							var mapIconStyle = GetDataByObjectNameOrRelationFromMap(objectName, global.MapIconStyleData);
							var mapIcon = new MapIcon(
								objectName,
								// TOP-LEFT CORNER TO DRAW RECTANGLE
								new Vector2(
									instance.x - instance.sprite_xoffset,
									instance.y - instance.sprite_yoffset
								),
								new Vector2(
									instance.x,
									instance.y
								),
								new Size(
									instance.sprite_width,
									instance.sprite_height
								),
								mapIconStyle,
								(instance.mask_index != SPRITE_NO_MASK) ? 1 : 0.3
							);
							ds_list_add(mapIcons, mapIcon);
						}
					}*/
				}
			}
		}
		return mapIcons;
	}
	
	static ReadStaticMapDataFromFile = function(_fileName)
	{
		var isMapDataReaded = false;
		var formatFileName = string("{0}{1}", "/map_data/", _fileName);
		var staticMapDataStruct = ReadJSONFile(formatFileName) ?? EMPTY_STRUCT;
		var parsedMapData = ds_list_create();
		ParseJSONStructToList(parsedMapData, staticMapDataStruct[$ "icons"] ?? undefined, ParseJSONStructToMapIcon);
		
		// DESTROY PREV ICONS DS LIST
		DestroyDSMapAndDeleteValues(static_map_data.icons);
		static_map_data.icons = parsedMapData;
		static_map_data.SortIcons();
		
		isMapDataReaded = true;
		return isMapDataReaded;
	}
	
	static ClearStaticMapData = function()
	{
		static_map_data.ClearIcons();
	}
	
	static ClearDynamicMapData = function()
	{
		dynamic_map_data.ClearIcons();
	}
	
	static ResetMapDataUpdate = function()
	{
		target_scout_region = undefined;
		scouting_drone = undefined;
		is_dynamic_data_updating = false;
		map_update_timer.StopTimer();	
	}
}