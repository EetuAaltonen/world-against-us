function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (!is_undefined(itemGridIndex))
	{
		var sourceItem = _inventory.GetItemByGridIndex(itemGridIndex).Clone();
		if (!is_undefined(sourceItem))
		{
			if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
			{
				var targetInventory = global.ObjTempInventory.inventory;
				if (!is_undefined(targetInventory))
				{
					var transferItemGridIndex = targetInventory.AddItem(sourceItem, undefined, false, sourceItem.is_known);
					if (!is_undefined(transferItemGridIndex))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);	
					}
				} else {
					if (sourceItem.category == "Magazine" || sourceItem.category == "Bullet" ||
						sourceItem.category == "Fuel Ammo")
					{
						if (!is_undefined(global.PlayerAmmoPockets))
						{
							var transferItemGridIndex = global.PlayerAmmoPockets.AddItem(sourceItem, undefined, false, sourceItem.is_known);
							if (!is_undefined(transferItemGridIndex))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					} else if (sourceItem.category == "Medicine")
					{
						if (!is_undefined(global.PlayerMedicinePockets))
						{
							var transferItemGridIndex = global.PlayerMedicinePockets.AddItem(sourceItem, undefined, false, sourceItem.is_known);
							if (!is_undefined(transferItemGridIndex))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}
				}
			} else {
				if (!is_undefined(global.PlayerBackpack))
				{
					var transferItemGridIndex = global.PlayerBackpack.AddItem(sourceItem, undefined, false, sourceItem.is_known);
					if (!is_undefined(transferItemGridIndex))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);
					}
				}
			}	
		}
	}
}