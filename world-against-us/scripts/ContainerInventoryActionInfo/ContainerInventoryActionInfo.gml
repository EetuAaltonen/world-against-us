function ContainerInventoryActionInfo(_container_id, _source_grid_index, _target_grid_index, _is_rotated, _is_known, _item) constructor
{
	container_id = _container_id;
	source_grid_index = _source_grid_index;
	target_grid_index = _target_grid_index;
	is_rotated = _is_rotated;
	is_known = _is_known;
	item = _item;
	
	static ToJSONStruct = function()
	{
		var formatItem = (!is_undefined(item)) ? item.ToJSONStruct() : item;
		return {
			container_id: container_id,
			source_grid_index: source_grid_index,
			target_grid_index: target_grid_index,
			is_rotated: is_rotated,
			is_known: is_known,
			item: formatItem
		};
	}
}