function DragItem(_item_data) constructor
{
	item_data = _item_data;
	
	original_grid_index = _item_data.grid_index;
	original_is_rotated = _item_data.is_rotated;
	original_is_known = _item_data.is_known;
	
	static RestoreOriginalItem = function()
	{
		var restoredItemGridIndex = item_data.sourceInventory.AddItem(
			item_data, original_grid_index,
			original_is_rotated, original_is_known
		);
		if (is_undefined(restoredItemGridIndex))
		{
			throw (string("Failed to restore dragged item {0}", item_data.name));
		}
	}
}