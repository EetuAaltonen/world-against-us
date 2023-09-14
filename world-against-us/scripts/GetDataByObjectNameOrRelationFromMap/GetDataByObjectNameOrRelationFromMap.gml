function GetDataByObjectNameOrRelationFromMap(_objectName, _map)
{
	var data = undefined;
	if (!is_undefined(_objectName))
	{
		var parentObjectName = GetParentObjectNameByObjectName(_objectName);
		var data = (_map[? _objectName] ?? _map[? parentObjectName]) ?? undefined;
	}
	return data;
}