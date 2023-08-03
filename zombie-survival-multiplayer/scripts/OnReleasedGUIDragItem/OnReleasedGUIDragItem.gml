function OnReleasedGUIDragItem(_inventory, _mouseHoverIndex)
{
	var sourceInventory = global.ObjMouse.dragItem.sourceInventory;
	var sourceItem = sourceInventory.GetItemByGridIndex(global.ObjMouse.dragItem.grid_index);
	
	if (!is_undefined(sourceItem))
	{
		if (_inventory.IsGridAreaEmpty(_mouseHoverIndex.col, _mouseHoverIndex.row, sourceItem, sourceInventory, sourceItem.grid_index))
		{
			if (_inventory.inventory_id == sourceInventory.inventory_id)
			{
				_inventory.MoveAndRotateItemByGridIndex(sourceItem.grid_index, _mouseHoverIndex, sourceItem.is_rotated);
			} else {
				if (_inventory.AddItem(sourceItem.Clone(), _mouseHoverIndex, sourceItem.known))
				{
					sourceInventory.RemoveItemByGridIndex(sourceItem.grid_index);
				
					// SET EQUIPPED WEAPON TO UNDEFINED
					if (sourceInventory.inventory_id == "PlayerPrimaryWeaponSlot")
					{
						CallbackItemSlotPrimaryWeapon(undefined);
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
		} else {
			// ITEM DROP ACTIONS
			var targetItemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
			if (!is_undefined(targetItemGridIndex))
			{
				var targetItem = _inventory.GetItemByGridIndex(targetItemGridIndex);
				if (!is_undefined(targetItem))
				{
					// STACK ITEMS
					if (sourceItem.Compare(targetItem))
					{
						targetItem.Stack(sourceItem);
						if (sourceItem.quantity <= 0)
						{
							sourceInventory.RemoveItemByGridIndex(sourceItem.grid_index);
						}
		
					// RELOAD MAGAZINE
					} else if (sourceItem.category == "Bullet")
					{
						if (targetItem.category == "Magazine")
						{
							if (targetItem.metadata.caliber == sourceItem.metadata.caliber)
							{
								InventoryReloadMagazine(targetItem, sourceItem);
							}
						} else if (targetItem.category == "Weapon" && targetItem.type == "Shotgun")
						{
							if (targetItem.metadata.chamber_type == "Shell")
							{
								if (sourceItem.type == "Shotgun Shell")
								{
									if (targetItem.metadata.caliber == sourceItem.metadata.caliber)
									{
										InventoryReloadWeaponShotgun(targetItem, sourceItem);
									}
								}
							}
						}
					} else if (sourceItem.category == "Magazine")
					{
						if (targetItem.category == "Weapon" && targetItem.type != "Melee")
						{
							if (targetItem.metadata.caliber == sourceItem.metadata.caliber)
							{
								InventoryReloadWeaponGun(targetItem, sourceItem);
							}
						}
					} else if (sourceItem.category == "Fuel Ammo")
					{
						if (targetItem.category == "Weapon" && targetItem.type == "Flamethrower")
						{
							if (targetItem.metadata.caliber == sourceItem.metadata.caliber)
							{
								InventoryReloadWeaponFlamethrower(targetItem, sourceItem);
							}
						}
					}
				}
			}
		}
	}
}