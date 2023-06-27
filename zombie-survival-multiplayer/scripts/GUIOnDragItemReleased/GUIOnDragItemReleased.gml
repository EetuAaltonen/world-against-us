function GUIOnDragItemReleased(_inventory, _mouseHoverIndex)
{
	if (_inventory.IsGridAreaEmpty(_mouseHoverIndex.col, _mouseHoverIndex.row, global.ObjMouse.dragItem, global.ObjMouse.dragItem.sourceInventory, global.ObjMouse.dragItem.grid_index))
	{
		var inventorySource = global.ObjMouse.dragItem.sourceInventory;
		if (_inventory.inventoryId == inventorySource.inventoryId)
		{
			_inventory.MoveAndRotateItemByGridIndex(global.ObjMouse.dragItem.grid_index, _mouseHoverIndex, global.ObjMouse.dragItem.is_rotated);
		} else {
			if (_inventory.AddItem(global.ObjMouse.dragItem.Clone(), _mouseHoverIndex, global.ObjMouse.dragItem.known))
			{
				inventorySource.RemoveItemByGridIndex(global.ObjMouse.dragItem.grid_index);
			}
		}
	} else {
		// ITEM DROP ACTIONS
		var targetItemGridIndex = _inventory.gridData[_mouseHoverIndex.row][_mouseHoverIndex.col];
		if (!is_undefined(targetItemGridIndex))
		{
			var targetItem = _inventory.GetItemByGridIndex(targetItemGridIndex);
			if (!is_undefined(targetItem))
			{
				// STACK ITEMS
				if (global.ObjMouse.dragItem.Compare(targetItem))
				{
					var availableStackSize = targetItem.max_stack - targetItem.quantity;
					var quantityToStack = min(availableStackSize, global.ObjMouse.dragItem.quantity);
					if (quantityToStack > 0)
					{
						targetItem.quantity += quantityToStack;
						global.ObjMouse.dragItem.quantity -= quantityToStack;
						if (global.ObjMouse.dragItem.quantity <= 0)
						{
							global.ObjMouse.dragItem.sourceInventory.RemoveItemByGridIndex(global.ObjMouse.dragItem.grid_index);
						}
					}
		
				// RELOAD MAGAZINE
				} else if (global.ObjMouse.dragItem.type == "Bullet")
				{
					if (targetItem.type == "Magazine")
					{
						if (targetItem.metadata.caliber == global.ObjMouse.dragItem.metadata.caliber)
						{
							var sourceItem = global.ObjMouse.dragItem.sourceInventory.GetItemByGridIndex(global.ObjMouse.dragItem.grid_index);
							var reloadCount = min(sourceItem.quantity, (targetItem.metadata.capacity - array_length(targetItem.metadata.bullets)));
							repeat(reloadCount)
							{
								targetItem.metadata.LoadBullet(sourceItem.Clone(1));
								sourceItem.quantity--;
							}
							if (sourceItem.quantity <= 0)
							{
								sourceItem.sourceInventory.RemoveItemByGridIndex(sourceItem.grid_index);
							}
						}
					}
				} else if (global.ObjMouse.dragItem.type == "Magazine")
				{
					if (targetItem.type == "Primary_Weapon")
					{
						if (targetItem.metadata.caliber == global.ObjMouse.dragItem.metadata.caliber)
						{
							InventoryReloadWeapon(targetItem, global.ObjMouse.dragItem);
						}
					}
				}
			}
		}
	}
}