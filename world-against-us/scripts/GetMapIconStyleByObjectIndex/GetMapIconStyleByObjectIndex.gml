function GetMapIconStyleByObjectIndex(_objectIndex)
{
	var mapIconStyle = undefined;
	if (object_exists(_objectIndex))
	{
		var mapIconStyleData = global.MapIconStyleData[? _objectIndex] ?? global.MapIconStyleData[? object_get_parent(_objectIndex)];
		if (!is_undefined(mapIconStyleData))
		{
			mapIconStyle = mapIconStyleData;
		}
	}
	return mapIconStyle;
}