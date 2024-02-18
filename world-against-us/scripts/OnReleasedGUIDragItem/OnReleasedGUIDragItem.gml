function OnReleasedGUIDragItem(_inventory, _mouseHoverIndex)
{
	var isDragItemDropped = false;
	
	if (!is_undefined(global.ObjMouse.dragItem))
	{
		var dragItemData = global.ObjMouse.dragItem.item_data;
		if (_inventory.IsGridAreaEmpty(_mouseHoverIndex.col, _mouseHoverIndex.row, dragItemData))
		{
			var droppedItemGridIndex = _inventory.AddItem(dragItemData, _mouseHoverIndex, dragItemData.is_rotated);
			if (!is_undefined(droppedItemGridIndex))
			{
				// NETWORKING DEPOSIT ITEM
				NetworkInventoryDepositItem(_inventory, droppedItemGridIndex);
				
				// SET EQUIPPED WEAPON TO UNDEFINED
				if (dragItemData.sourceInventory.inventory_id == "PlayerPrimaryWeaponSlot" && _inventory.inventory_id != dragItemData.sourceInventory.inventory_id)
				{
					CallbackItemSlotPlayerPrimaryWeapon(undefined);
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
				isDragItemDropped = true;
			}
		} else {
			// ITEM DROP ACTIONS
			var targetItemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
			if (!is_undefined(targetItemGridIndex))
			{
				var targetItem = _inventory.GetItemByGridIndex(targetItemGridIndex);
				if (!is_undefined(targetItem))
				{
					var sourceQuantity = dragItemData.quantity;
					if (CombineItems(dragItemData, targetItem))
					{
						// NETWORKING STACK ITEM
						NetworkInventoryStackItem(_inventory, sourceQuantity, dragItemData, targetItem);
						
						isDragItemDropped = true;
					}
				}
			}
		}
	}
	
	return isDragItemDropped;
}