function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.gridData[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (!is_undefined(itemGridIndex))
	{
		var cloneItem = _inventory.GetItemByGridIndex(itemGridIndex).Clone();
		if (!is_undefined(cloneItem))
		{
			// RESET ITEM ROTATION
			if (cloneItem.is_rotated) { cloneItem.Rotate(); }
			
			if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
			{
				var targetInventory = global.ObjTempInventory.inventory;
				if (!is_undefined(targetInventory))
				{
					if (targetInventory.AddItem(cloneItem, undefined, cloneItem.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);	
					}
				} else {
					if (cloneItem.category == "Magazine" || cloneItem.category == "Bullet")
					{
						if (!is_undefined(global.PlayerMagazinePockets))
						{
							if (global.PlayerMagazinePockets.AddItem(cloneItem, undefined, cloneItem.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					} else if (cloneItem.category == "Medicine")
					{
						if (!is_undefined(global.PlayerMedicinePockets))
						{
							if (global.PlayerMedicinePockets.AddItem(cloneItem, undefined, cloneItem.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}
				}
			} else {
				if (!is_undefined(global.PlayerBackpack))
				{
					if (global.PlayerBackpack.AddItem(cloneItem, undefined, cloneItem.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);
					}
				}
			}	
		}
	}
}