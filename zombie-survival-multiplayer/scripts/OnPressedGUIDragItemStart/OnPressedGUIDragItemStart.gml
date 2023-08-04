function OnPressedGUIDragItemStart(_item)
{
	// SET DRAGGED ITEM
	global.ObjMouse.dragItem = new DragItem(_item);
	
	// REMOVE IT FROM THE SOURCE INVENTORY
	_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
}