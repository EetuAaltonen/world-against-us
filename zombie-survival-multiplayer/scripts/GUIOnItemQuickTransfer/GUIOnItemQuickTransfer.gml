function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.gridData[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (itemGridIndex != noone)
	{
		var item = _inventory.GetItemByGridIndex(itemGridIndex);
		if (!is_undefined(item))
		{						
			if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
			{
				var targetInventory = global.ObjTempInventory.inventory;
				if (targetInventory != noone)
				{
					if (targetInventory.AddItem(item.Clone(), noone, item.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);	
					}
				} else {
					if (item.type == "Magazine" || item.type == "Ammo")
					{
						if (global.PlayerMagazinePockets != noone)
						{
							if (global.PlayerMagazinePockets.AddItem(item.Clone(), noone, item.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					} else if (item.type == "Medicine")
					{
						if (global.PlayerMedicinePockets != noone)
						{
							if (global.PlayerMedicinePockets.AddItem(item.Clone(), noone, item.known))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}
				}
			} else {
				if (global.PlayerBackpack != noone)
				{
					if (global.PlayerBackpack.AddItem(item.Clone(), noone, item.known))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);
					}
				}
			}	
		}
	}
}