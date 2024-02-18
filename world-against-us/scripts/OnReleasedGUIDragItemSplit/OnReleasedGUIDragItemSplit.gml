function OnReleasedGUIDragItemSplit(_inventory, _mouseHoverIndex)
{
	var isDragItemStackEmpty = false;

	if (!is_undefined(global.ObjMouse.dragItem))
	{
		var dragItemData = global.ObjMouse.dragItem.item_data;
		if (dragItemData.max_stack > 1)
		{
			var splitQuantity = keyboard_check(vk_shift) ? ceil(dragItemData.quantity * 0.5) : 1;
			if (_inventory.IsGridAreaEmpty(_mouseHoverIndex.col, _mouseHoverIndex.row, dragItemData, undefined, undefined))
			{
				var splitItemGridIndex = _inventory.AddItem(dragItemData.Clone(splitQuantity, true), _mouseHoverIndex, dragItemData.is_rotated);
				if (!is_undefined(splitItemGridIndex))
				{
					dragItemData.quantity -= splitQuantity;
					
					// NETWORKING DEPOSIT ITEM
					NetworkInventoryDepositItem(_inventory, _mouseHoverIndex);
				}
			} else {
				var targetItemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
				if (!is_undefined(targetItemGridIndex))
				{
					var targetItem = _inventory.GetItemByGridIndex(targetItemGridIndex);
					if (!is_undefined(targetItem))
					{
						var itemCloneToCombine = dragItemData.Clone(splitQuantity);
						if (CombineItems(itemCloneToCombine, targetItem))
						{
							isDragItemStackEmpty = true;
						}
						
						// CHECK IF DRAG ITEM STACK IS EMPTY
						dragItemData.quantity -= (isDragItemStackEmpty) ? splitQuantity : (splitQuantity - itemCloneToCombine.quantity);
						isDragItemStackEmpty = (dragItemData.quantity <= 0);
					}
				}
			}
		}
	}
	
	return isDragItemStackEmpty;
}