function OnReleasedGUIDragItem(_inventory, _mouseHoverIndex)
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
					targetItem.Stack(global.ObjMouse.dragItem);
					if (global.ObjMouse.dragItem.quantity <= 0)
					{
						var inventorySource = global.ObjMouse.dragItem.sourceInventory;
						inventorySource.RemoveItemByGridIndex(global.ObjMouse.dragItem.grid_index);
					}
		
				// RELOAD MAGAZINE
				} else if (global.ObjMouse.dragItem.category == "Bullet")
				{
					if (targetItem.category == "Magazine")
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
					} else if (targetItem.category == "Weapon" && targetItem.type == "Shotgun")
					{
						if (targetItem.metadata.chamber_type == "Shell")
						{
							if (global.ObjMouse.dragItem.type == "Shotgun Shell")
							{
								if (targetItem.metadata.caliber == global.ObjMouse.dragItem.metadata.caliber)
								{
									InventoryReloadWeaponShotgun(targetItem, global.ObjMouse.dragItem);
								}
							}
						}
					}
				} else if (global.ObjMouse.dragItem.category == "Magazine")
				{
					if (targetItem.category == "Weapon" && targetItem.type != "Melee")
					{
						if (targetItem.metadata.caliber == global.ObjMouse.dragItem.metadata.caliber)
						{
							InventoryReloadWeaponGun(targetItem, global.ObjMouse.dragItem);
						}
					}
				} else if (global.ObjMouse.dragItem.category == "Fuel Tank")
				{
					if (targetItem.category == "Weapon" && targetItem.type == "Flamethrower")
					{
						if (targetItem.metadata.caliber == global.ObjMouse.dragItem.metadata.caliber)
						{
							InventoryReloadWeaponFlamethrower(targetItem, global.ObjMouse.dragItem);
						}
					}
				}
			}
		}
	}
}