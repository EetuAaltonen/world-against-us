function GetDataByObjectNameOrRelationFromMap(_objectName, _map)
{
	var data = undefined;
	if (!is_undefined(_objectName))
	{
		data = _map[? _objectName] ?? undefined;
		if (is_undefined(data))
		{
			var objectNameToCheck = _objectName;
			while (true)
			{
				var parentObjectIndex = GetParentObjectIndexByChildObjectName(objectNameToCheck);
				if (object_exists(parentObjectIndex))
				{
					objectNameToCheck = object_get_name(parentObjectIndex);
					data = _map[? objectNameToCheck] ?? undefined;
					if (!is_undefined(data)) break;
				} else {
					break;
				}
			}
		}
	}
	return data;
}