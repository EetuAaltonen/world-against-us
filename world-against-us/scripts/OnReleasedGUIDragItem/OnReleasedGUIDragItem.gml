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
						if (global.MultiplayerMode)
						{
							if (IsInventoryContainer(_inventory.type))
							{
								// TODO: Simplify combine logic
								var stackedSourceItem = dragItemData.Clone();
								// PATCH GRID INDEX
								stackedSourceItem.grid_index = targetItem.grid_index.Clone();
								// PATCH STACK OPERATION QUANTITY
								stackedSourceItem.quantity = sourceQuantity - dragItemData.quantity;
								var containerInventoryActionInfo = new ContainerInventoryActionInfo(_inventory.inventory_id, undefined, undefined, undefined, undefined, stackedSourceItem);
								var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STACK_ITEM);
								var networkPacket = new NetworkPacket(
									networkPacketHeader,
									containerInventoryActionInfo.ToJSONStruct(),
									PACKET_PRIORITY.DEFAULT,
									AckTimeoutFuncResend
								);
								if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
								{
									show_debug_message("Failed to stack item to container inventory");
								}
								// DELETE TEMP STACKED SOURCE ITEM
								stackedSourceItem.OnDestroy();
								stackedSourceItem = undefined;
							}
						}
						isDragItemDropped = true;
					}
				}
			}
		}
	}
	
	return isDragItemDropped;
}