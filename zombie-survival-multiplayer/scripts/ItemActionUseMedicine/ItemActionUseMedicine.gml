function ItemActionUseMedicine(_item)
{
	global.ObjPlayer.character.UseMedicine(_item);
	if (_item.metadata.healing_left <= 0)
	{
		_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
	}
}