function MapData() constructor
{
	icons = ds_list_create();
	prioritized_icons = [];
	
	static ToJSONStruct = function()
	{
		var formatMapIcons = [];
		var mapIconCount = ds_list_size(icons);
		for (var i = 0; i < mapIconCount; i++)
		{
			var mapIcon = icons[| i];
			array_push(formatMapIcons, mapIcon.ToJSONStruct());
		}
		
		return {
			icons: formatMapIcons
		}
	}
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(icons);
		icons = undefined;
	}
	
	static SortIcons = function()
	{
		SortList(icons, CompareMapIcons);
	}
	
	static GetMapIconByIndex = function(_index)
	{
		return icons[| _index];
	}
	
	static GetMapIconCount = function()
	{
		return ds_list_size(icons);
	}
	
	static AddPrioritizedIcon = function(_mapIcon)
	{
		array_push(prioritized_icons, _mapIcon)
	}
	
	static IsIconOverlappingWithPrioritized = function(_mapIcon)
	{
		var isOverlapping = false;
		var prioritizedIconCount = array_length(prioritized_icons);
		for (var i = 0; i < prioritizedIconCount; i++)
		{
			var prioritizedIcon = prioritized_icons[@ i];
			if (!is_undefined(prioritizedIcon))
			{
				isOverlapping = rectangle_in_rectangle(
					_mapIcon.position.X, _mapIcon.position.Y,
					_mapIcon.position.X + _mapIcon.size.w,
					_mapIcon.position.Y + _mapIcon.size.h,
					prioritizedIcon.position.X, prioritizedIcon.position.Y,
					prioritizedIcon.position.X + prioritizedIcon.size.w,
					prioritizedIcon.position.Y + prioritizedIcon.size.h
				);
				if (isOverlapping) break;
			}
		}
		return isOverlapping;
	}
	
	static ResetPrioritizedIcons = function()
	{
		prioritized_icons = [];	
	}
	
	static ClearIcons = function()
	{
		ClearDSListAndDeleteValues(icons);
	}
}