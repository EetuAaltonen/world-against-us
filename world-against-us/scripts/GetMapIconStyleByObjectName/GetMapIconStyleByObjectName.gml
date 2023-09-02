function GetMapIconStyleByObjectName(_objectName)
{
	var mapIconStyle = undefined;
	if (!is_undefined(_objectName))
	{
		var objectIndex = asset_get_index(_objectName);
		var parentObjectName = object_get_name(object_get_parent(objectIndex));
		var mapIconStyleData = (global.MapIconStyleData[? _objectName] ?? global.MapIconStyleData[? parentObjectName]) ?? undefined;
		if (!is_undefined(mapIconStyleData))
		{
			mapIconStyle = mapIconStyleData;
		}
	}
	return mapIconStyle;
}