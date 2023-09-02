function MapDataHandler() constructor
{
	static_map_data = new MapData();
	map_update_timer = new Timer(TimerFromSeconds(6));
	
	static GetMapDataFileName = function(roomName)
	{
		return string("{0}_static_map.json", roomName);
	}
	
	static GenerateStaticMapData = function()
	{
		var isMapDataGenerated = false;
		var roomName = room_get_name(room);
		var fileName = string("{0}{1}", "DEBUG/map_data/", GetMapDataFileName(roomName));
		var mapData = new MapData();
		try
		{
			for (var key = ds_map_find_first(global.MapIconStyleData); !is_undefined(key); key = ds_map_find_next(global.MapIconStyleData, key))
			{
				var iconStyle = global.MapIconStyleData[? key];
				if (!is_undefined(iconStyle))
				{
					if (!iconStyle.is_dynamic)
					{
						var styleObjectIndex = asset_get_index(iconStyle.object_name);
						var instanceCount = instance_number(styleObjectIndex);
						for (var i = 0; i < instanceCount; i++)
						{
							var instance = instance_find(styleObjectIndex, i);
							if (instance_exists(instance))
							{
								var objectName = object_get_name(instance.object_index);
								var mapIconStyle = GetMapIconStyleByObjectName(objectName);
								var mapIcon = new MapIcon(
									objectName,
									// TOP-LEFT CORNER TO DRAW RECTANGLE
									new Vector2(
										instance.x - instance.sprite_xoffset,
										instance.y - instance.sprite_yoffset
									),
									new Size(
										instance.sprite_width,
										instance.sprite_height
									),
									mapIconStyle,
									(instance.mask_index != SPRITE_NO_MASK) ? 1 : 0.3
								);
								mapData.AddMapIcon(mapIcon);
							}
						}
					}
				}
			}
			
			var mapDataString = json_stringify(mapData.ToJSONStruct());
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
		return isMapDataGenerated;
	}
	
	static ReadStaticMapDataFile = function(_fileName)
	{
		var isMapDataReaded = false;
		
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
		static_map_data.Clear();
	}
}