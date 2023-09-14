function GetParentObjectNameByObjectName(_objectName)
{
	var objectIndex = asset_get_index(_objectName);
	var parentObjectName = object_get_name(object_get_parent(objectIndex));
	return parentObjectName;
}