function MapData() constructor
{
	icons = ds_list_create();
	
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
	
	static AddMapIcon = function(_mapIcon)
	{
		ds_list_add(icons, _mapIcon);
	}
	
	static GetMapIconByIndex = function(_index)
	{
		return icons[| _index];
	}
	
	static GetMapIconCount = function()
	{
		return ds_list_size(icons);
	}
	
	static Clear = function()
	{
		ds_list_clear(icons);
	}
}