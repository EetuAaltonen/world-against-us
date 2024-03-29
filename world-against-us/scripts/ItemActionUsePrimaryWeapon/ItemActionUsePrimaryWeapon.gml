function ItemActionUsePrimaryWeapon(_item)
{
	if (_item.sourceInventory.type == INVENTORY_TYPE.PlayerBackpack)
	{
		if (global.InstanceWeapon != noone)
		{
			if (!_item.Compare(global.InstanceWeapon.primaryWeapon))
			{
				var equippedWeapon = global.PlayerPrimaryWeaponSlot.GetItemByIndex(0);
				if (is_undefined(equippedWeapon))
				{
					var equippedWeaponGridIndex = global.PlayerPrimaryWeaponSlot.AddItem(_item, undefined, false)
					if (!is_undefined(equippedWeaponGridIndex))
					{
						_item.sourceInventory.RemoveItemByGridIndex(_item.grid_index);
						
						var playerBackpackWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.PlayerBackpack);
						if (!is_undefined(playerBackpackWindow))
						{
							var primaryWeaponSlot = playerBackpackWindow.GetChildElementById("PrimaryWeaponSlot");
							if (!is_undefined(primaryWeaponSlot))
							{
								primaryWeaponSlot.initItem = true;
							}
						}
					}
				} else {
					if (_item.sourceInventory.SwapWithRollback(_item, equippedWeapon))
					{
						var playerBackpackWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.PlayerBackpack);
						if (!is_undefined(playerBackpackWindow))
						{
							var primaryWeaponSlot = playerBackpackWindow.GetChildElementById("PrimaryWeaponSlot");
							if (!is_undefined(primaryWeaponSlot))
							{
								primaryWeaponSlot.initItem = true;
							}
						}
					}
				}
			}
		}
	}
}