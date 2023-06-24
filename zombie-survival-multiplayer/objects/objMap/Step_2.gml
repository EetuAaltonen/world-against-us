if (!global.GUIStateHandlerRef.IsGUIStateClosed())
{
	var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
	if (currentGUIState.index == GUI_STATE.Map)
	{
		if (mapUpdateTimer-- <= 0)
		{
			// CLEAR OLD INSTANCE REGISTRY
			ds_list_clear(mapEntryRegistry);
			
			for (var key = ds_map_find_first(global.MapIconStyleData); !is_undefined(key); key = ds_map_find_next(global.MapIconStyleData, key)) {
				var instanceType = key;
				var instanceCount = instance_number(instanceType);
				for (var i = 0; i < instanceCount; i++)
				{
					var instance = instance_find(instanceType, i);
					if (instance_exists(instance))
					{
						ds_list_add(mapEntryRegistry, new MapEntry(
							instance,
							new Size(
								instance.sprite_width,
								instance.sprite_height
							),
							new Vector2(instance.sprite_xoffset, instance.sprite_yoffset),
							GetMapIconStyleByObjectIndex(instance.object_index)
						));
					}
				}
			}
			
			mapUpdateTimer = mapUpdateInterval;
		}
	}
}