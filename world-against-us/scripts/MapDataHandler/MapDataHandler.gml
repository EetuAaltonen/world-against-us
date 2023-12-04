function MapDataHandler() constructor
{
	static_map_data = new MapData();
	dynamic_map_data = new MapData();
	
	is_dynamic_data_updating = false;
	map_update_timer = new Timer(TimerFromMilliseconds(300));
	
	scouting_drone = undefined;
	
	static GetMapDataFileName = function(roomName)
	{
		return string("{0}_static_map.json", roomName);
	}
	
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
	
	static UpdateDynamicMapData = function()
	{
		// TODO: Disabled during prototyping
		/*dynamic_map_data.icons = GenerateMapIcons(DYNAMIC_MAP_ICON);
		dynamic_map_data.SortIcons();*/
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
	
	static ReadStaticMapDataFile = function(_fileName)
	{
		var isMapDataReaded = false;
		
		// CLEAR STATIC MAP DATA
		ClearStaticMapData();
		
		var formatFileName = string("{0}{1}", "/map_data/", _fileName);
		var staticMapDataStruct = ReadJSONFile(formatFileName) ?? EMPTY_STRUCT;
		var parsedMapData = ParseJSONStructToList(staticMapDataStruct[$ "icons"] ?? undefined, ParseJSONStructToMapIcon);
		
		if (ds_list_size(parsedMapData) > 0)
		{
			static_map_data.icons = parsedMapData
			static_map_data.SortIcons();
			
			isMapDataReaded = true;
		}
		
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
}