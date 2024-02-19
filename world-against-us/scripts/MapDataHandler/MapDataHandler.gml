function MapDataHandler() constructor
{
	static_map_data = new MapData();
	dynamic_map_data = new MapData();
	
	is_dynamic_data_updating = false;
	map_update_timer = new Timer(MAP_DATA_UPDATE_INTERVAL);
	
	target_scout_region = undefined;
	active_operations_scout_stream = undefined;
	scouting_drone = undefined;
	
	static Update = function()
	{
		if (is_dynamic_data_updating)
		{
			map_update_timer.Update();
			if (map_update_timer.IsTimerStopped())
			{
				UpdateDynamicMapData();
				map_update_timer.StartTimer();
			}
			
			// UPDATE DYNAMIC MAP SIMULATED INTERPOLATION
			UpdateDynamicMapSimulatedInterpolation();
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
				var scoutingDroneData = new ScoutingDroneData(
					target_scout_region.region_id,
					scouting_drone.position
				);
				var formatScoutingDroneData = scoutingDroneData.ToJSONStruct();
				
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					formatScoutingDroneData,
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
	
	static UpdateDynamicMapSimulatedInterpolation = function()
	{
		var dynamicMapIconCount = ds_list_size(dynamic_map_data.icons);
		for (var i = 0; i < dynamicMapIconCount; i++)
		{
			var dynamicMapIcon = dynamic_map_data.icons[| i];
			if (!is_undefined(dynamicMapIcon))
			{
				var simulatedInstanceObject = dynamicMapIcon.simulated_instance_object;
				if (!is_undefined(simulatedInstanceObject))
				{
					simulatedInstanceObject.InterpolateMovement();
					
					var banditSpriteSize = new Size(
						sprite_get_width(sprBandit),
						sprite_get_height(sprBandit)
					);
					var positionWithOffset = new Vector2(
						simulatedInstanceObject.position.X - (banditSpriteSize.w * 0.5),
						simulatedInstanceObject.position.Y - (banditSpriteSize.h)
					);
					dynamicMapIcon.position = positionWithOffset;
				}
			}
		}
	}
	
	static SyncDynamicMapData = function(_regionSnapshot)
	{
		// TODO: Optimize and simplify this code
		var worldMapLocation = global.WorldMapLocationData[? target_scout_region.room_index];
		if (!is_undefined(worldMapLocation))
		{
			var patrolPath = worldMapLocation.patrol_path;
			if (!is_undefined(patrolPath))
			{
				var banditMapIconStyle = global.MapIconStyleData[? object_get_name(objBandit)];
				if (!is_undefined(banditMapIconStyle))
				{
					var banditSpriteSize = new Size(
						sprite_get_width(sprBandit),
						sprite_get_height(sprBandit)
					);
					// PATCH EXISTENT PATROL MAP ICONS
					var dynamicIconCount = ds_list_size(dynamic_map_data.icons);
					for (var i = 0; i < dynamicIconCount; i++)
					{
						var dynamicMapIcon = dynamic_map_data.icons[| i];
						if (!is_undefined(dynamicMapIcon))
						{
							var existentPatrolIndex = undefined;
							var patrolCount = array_length(_regionSnapshot.local_patrols);
							for (var j = 0; j < patrolCount; j++)
							{
								var patrol = _regionSnapshot.local_patrols[@ j];
								if (!is_undefined(patrol))
								{
									if (dynamicMapIcon.simulated_instance_object.network_id == patrol.patrol_id &&
										dynamicMapIcon.simulated_instance_object.obj_index == objBandit)
									{
										existentPatrolIndex = j;
										break;
									}
								}
							}
						
							if (!is_undefined(existentPatrolIndex))
							{
								var patrol = _regionSnapshot.local_patrols[@ existentPatrolIndex];								
								var patrolPosition = new Vector2(
									path_get_x(patrolPath, patrol.route_progress),
									path_get_y(patrolPath, patrol.route_progress)
								);
								// USE LOCAL POSITION IF OUTSIDE THE ROUTE
								if (patrol.local_position.X != 0 && patrol.local_position.Y != 0)
								{
									patrolPosition = patrol.local_position;
								}
								dynamicMapIcon.simulated_instance_object.StartInterpolateMovement(patrolPosition, 300);
								array_delete(_regionSnapshot.local_patrols, existentPatrolIndex, 1);
								patrolCount = array_length(_regionSnapshot.local_patrols);
							} else {
								// DELETE OUTDATED PATROL MAP ICONS
								if (dynamicMapIcon.object_name == object_get_name(objBandit))
								{
									ds_list_delete(dynamic_map_data.icons, i--);
									dynamicIconCount = ds_list_size(dynamic_map_data.icons);
								}
							}
						} else {
							// DELETE UNDEFINED MAP ICONS
							ds_list_delete(dynamic_map_data.icons, i--);
							dynamicIconCount = ds_list_size(dynamic_map_data.icons);
						}
					}
					// ADD NEW PATROL MAP ICONS
					var newPatrolIconCount = array_length(_regionSnapshot.local_patrols);
					for (var i = 0; i < newPatrolIconCount; i++)
					{
						var patrol = _regionSnapshot.local_patrols[@ i];
						if (!is_undefined(patrol))
						{
							var patrolPosition = new Vector2(
								path_get_x(patrolPath, patrol.route_progress),
								path_get_y(patrolPath, patrol.route_progress)
							);
							var positionWithOffset = new Vector2(
								patrolPosition.X - (banditSpriteSize.w * 0.5),
								patrolPosition.Y - (banditSpriteSize.h)
							);
							var mapIcon = new MapIcon(
								object_get_name(objBandit),
								// TOP-LEFT CORNER TO DRAW RECTANGLE
								positionWithOffset,
								patrolPosition,
								banditSpriteSize,
								banditMapIconStyle,
								1
							);
							mapIcon.simulated_instance_object = new InstanceObject(
								object_get_sprite(objBandit),
								objBandit,
								patrolPosition
							);
							mapIcon.simulated_instance_object.network_id = patrol.patrol_id;
							ds_list_add(dynamic_map_data.icons, mapIcon);
						}
					}
				}
			}
			
			var playerMapIconStyle = global.MapIconStyleData[? object_get_name(objPlayer)];
			if (!is_undefined(playerMapIconStyle))
			{
				var playerSpriteSize = new Size(
					sprite_get_width(sprSoldierOriginal),
					sprite_get_height(sprSoldierOriginal)
				);
				// PATCH EXISTENT PLAYER MAP ICONS
				var dynamicIconCount = ds_list_size(dynamic_map_data.icons);
				for (var i = 0; i < dynamicIconCount; i++)
				{
					var dynamicMapIcon = dynamic_map_data.icons[| i];
					if (!is_undefined(dynamicMapIcon))
					{
						var existentPlayerIndex = undefined;
						var playerCount = array_length(_regionSnapshot.local_players);
						for (var j = 0; j < playerCount; j++)
						{
							var player = _regionSnapshot.local_players[@ j];
							if (!is_undefined(player))
							{
								if (dynamicMapIcon.simulated_instance_object.network_id == player.network_id &&
									dynamicMapIcon.simulated_instance_object.obj_index == objPlayer)
								{
									existentPlayerIndex = j;
									break;
								}
							}
						}
						
						if (!is_undefined(existentPlayerIndex))
						{
							var player = _regionSnapshot.local_players[@ existentPlayerIndex];								
							var playerPosition = new Vector2(
								player.position.X,
								player.position.Y
							);
							dynamicMapIcon.simulated_instance_object.StartInterpolateMovement(playerPosition, 300);
							array_delete(_regionSnapshot.local_players, existentPlayerIndex, 1);
							playerCount = array_length(_regionSnapshot.local_players);
						} else {
							// DELETE OUTDATED PLAYER MAP ICONS
							if (dynamicMapIcon.object_name == object_get_name(objPlayer))
							{
								ds_list_delete(dynamic_map_data.icons, i--);
								dynamicIconCount = ds_list_size(dynamic_map_data.icons);
							}
						}
					} else {
						// DELETE UNDEFINED MAP ICONS
						ds_list_delete(dynamic_map_data.icons, i--);
						dynamicIconCount = ds_list_size(dynamic_map_data.icons);
					}
				}
				// ADD NEW PLAYER MAP ICONS
				var newPlayerIconCount = array_length(_regionSnapshot.local_players);
				for (var i = 0; i < newPlayerIconCount; i++)
				{
					var player = _regionSnapshot.local_players[@ i];
					if (!is_undefined(player))
					{
						var playerPosition = new Vector2(
							player.position.X,
							player.position.Y
						);
						var positionWithOffset = new Vector2(
							playerPosition.X - (playerSpriteSize.w * 0.5),
							playerPosition.Y - (playerSpriteSize.h)
						);
						var mapIcon = new MapIcon(
							object_get_name(objBandit),
							// TOP-LEFT CORNER TO DRAW RECTANGLE
							positionWithOffset,
							playerPosition,
							playerSpriteSize,
							playerMapIconStyle,
							1
						);
						mapIcon.simulated_instance_object = new InstanceObject(
							object_get_sprite(objPlayer),
							objPlayer,
							playerPosition
						);
						mapIcon.simulated_instance_object.network_id = player.network_id;
						ds_list_add(dynamic_map_data.icons, mapIcon);
					}
				}
			}
		}
		// SORT DYNAMIC MAP ICONS
		dynamic_map_data.SortIcons();
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
					var styleObjectIndex = asset_get_index(iconStyle.object_name);
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
					}
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
		static_map_data.OnDestroy();
		
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
	
	static ResetMapData = function()
	{
		target_scout_region = undefined;
		active_operations_scout_stream = undefined;
		scouting_drone = undefined;
		
		is_dynamic_data_updating = false;
		map_update_timer.StopTimer();	
	}
}