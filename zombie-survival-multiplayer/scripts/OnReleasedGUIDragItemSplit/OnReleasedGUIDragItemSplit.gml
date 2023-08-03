function OnReleasedGUIDragItemSplit(_inventory, _mouseHoverIndex)
{
	var sourceInventory = global.ObjMouse.dragItem.sourceInventory;
	var sourceItem = sourceInventory.GetItemByGridIndex(global.ObjMouse.dragItem.grid_index);
	
	if (!is_undefined(sourceItem))
	{
		if (sourceItem.max_stack > 1)
		{
			var slitQuantity = keyboard_check(vk_shift) ? ceil(sourceItem.quantity * 0.5) : 1;
			if (_inventory.IsGridAreaEmpty(_mouseHoverIndex.col, _mouseHoverIndex.row, sourceItem, undefined, undefined))
			{
				if (_inventory.AddItem(sourceItem.Clone(slitQuantity), _mouseHoverIndex, sourceItem.known))
				{
					global.ObjMouse.dragItem.quantity -= slitQuantity;
					sourceItem.quantity -= slitQuantity;
				
					if (sourceItem.quantity <= 0)
					{
						sourceInventory.RemoveItemByGridIndex(sourceItem.grid_index);
						global.ObjMouse.dragItem = undefined;
					}
				}
			} else {
				var targetItemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
				if (!is_undefined(targetItemGridIndex))
				{
					var targetItem = _inventory.GetItemByGridIndex(targetItemGridIndex);
					if (!is_undefined(targetItem))
					{
						// STACK ITEMS
						if (sourceItem.Compare(targetItem))
						{
							var itemToStack = sourceItem.Clone(slitQuantity);
							targetItem.Stack(itemToStack);
							
							var stackQuantity = slitQuantity - itemToStack.quantity/*remaining*/;
							global.ObjMouse.dragItem.quantity -= stackQuantity;
							sourceItem.quantity -= stackQuantity;
							
							if (sourceItem.quantity <= 0)
							{
								sourceInventory.RemoveItemByGridIndex(sourceItem.grid_index);
								global.ObjMouse.dragItem = undefined;
							}
						}
					}
				}
			}
		}
	}
}