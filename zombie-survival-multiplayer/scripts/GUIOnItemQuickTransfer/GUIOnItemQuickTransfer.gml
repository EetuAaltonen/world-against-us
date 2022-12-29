function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.gridData[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (!is_undefined(itemGridIndex))
	{
		var item = _inventory.GetItemByGridIndex(itemGridIndex);
		if (!is_undefined(item))
		{						
			if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
			{
				var targetInventory = global.ObjTempInventory.inventory;
				if (!is_undefined(targetInventory))
				{
					if (targetInventory.AddItem(item.Clone(), undefined, item.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);	
					}
				} else {
					if (item.type == "Magazine" || item.type == "Ammo")
					{
						if (!is_undefined(global.PlayerMagazinePockets))
						{
							if (global.PlayerMagazinePockets.AddItem(item.Clone(), undefined, item.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					} else if (item.type == "Medicine")
					{
						if (!is_undefined(global.PlayerMedicinePockets))
						{
							if (global.PlayerMedicinePockets.AddItem(item.Clone(), undefined, item.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}
				}
			} else {
				if (!is_undefined(global.PlayerBackpack))
				{
					if (global.PlayerBackpack.AddItem(item.Clone(), undefined, item.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);
					}
				}
			}	
		}
	}
}