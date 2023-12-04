function GetParentObjectIndexByChildObjectName(_childObjectName)
{
	return object_get_parent(asset_get_index(_childObjectName));
}