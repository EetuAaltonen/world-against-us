function ClearDSMapAndDeleteValues(_dsMap, _valueType = undefined)
{
	if (!is_undefined(_dsMap))
	{
		if (ds_exists(_dsMap, ds_type_map))
		{
			var mapSize = ds_map_size(_dsMap);
			repeat(mapSize)
			{
				var key = ds_map_find_first(_dsMap);
				DeleteDSMapValueByKey(_dsMap, key, _valueType);	
			}
			ds_map_clear(_dsMap);
		} else {
			// TODO: Generic error handling
			show_debug_message("Unable to clear unknown DS map");
		}
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS map");
	}
}